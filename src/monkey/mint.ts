import hre, { ethers } from 'hardhat';
import { getGasOption } from '../utils/gas';
import * as fs from 'fs';
import { Monkey } from '../../typechain';
import { BigNumber } from 'ethers';

function decodeBase64(base64String) {
  try {
    return Buffer.from(base64String, 'base64').toString('utf-8');
  } catch (error) {
    console.error('Base64 Decoding Error:', error);
    return null;
  }
}

async function main() {
  const [admin] = await ethers.getSigners();
  const chainId = hre.network.config.chainId || 0;
  const deployedContractJson = fs.readFileSync(
    __dirname + '/monkey.deployed.json',
    'utf-8',
  );
  const deployedContract = JSON.parse(deployedContractJson);
  const monkey = (await ethers.getContractAt(
    deployedContract.abi,
    deployedContract.address,
  )) as Monkey;
  //const reading = 400;
  const name = '윤영진';
  const birth = '990114';
  const score = 750;
  const testDate = '2023-10-02';
  const expirationDate = '2028-10-02';
  const transaction = await monkey.mint(
  
    name,
    birth,
    score,
    //reading,
    testDate,
    expirationDate,
    getGasOption(chainId),
  );
  await transaction.wait();

  let tokenId;
  const desiredTokenId = 0; //조회

  if (desiredTokenId === 0) {
    const tokenCount = await monkey.balanceOf(admin.address);
    tokenId = tokenCount.sub(1);
  } else {
    tokenId = BigNumber.from(desiredTokenId);
  }

  // 이전 NFT 정보 출력 부분
  try {
    const ownerAddress = await monkey.ownerOf(tokenId);
    console.log('Token ID: ', tokenId.toString());
    console.log('Owner Address: ', ownerAddress);

    const metadata = await monkey.getTokenURI(tokenId);
    console.log('Received Metadata:', metadata);

    const decodedData = decodeBase64(metadata.split('base64,')[1]);
    if (decodedData === null) {
      console.error('Error decoding JSON metadata');
      return;
    }
    console.log('Decoded JSON:', decodedData);

    try {
      const jsonData = JSON.parse(decodedData);


      delete jsonData.description;
      delete jsonData.image;


      jsonData.attributes[1].value = name;
       jsonData.attributes[2].value = birth;
      jsonData.attributes[3].value = score;
      //jsonData.attributes[4].value = reading;
      // jsonData.attributes.push({
      //   trait_type: 'Expiration Date',
      //   value: expirationDate,
      // });
      console.log('Parsed JSON:', jsonData);
    } catch (error) {
      console.error('Error parsing JSON:', error);
    }
  } catch (error) {
    console.error('Error retrieving token info:', error);
  }
}
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });