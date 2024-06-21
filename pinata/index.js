const path = require('path')
const fs = require('fs')
require('dotenv').config({ path: path.resolve(__dirname, '../.env') })


const pinataSDK = require('@pinata/sdk');
const pinata = new pinataSDK(process.env.PINATA_API_KEY, process.env.PINATA_SECRET_KEY)


//Function to upload an image to Pinata
async function uploadImage() {
  try {
    const stream = fs.createReadStream('../images/earthOnHand.jpg');
    const result = await pinata.pinFileToIPFS(stream, {
      wrapWithDirectory: false,
      pinataMetadata: {
        name: 'treeInHand.jpg',
      },
    })
   // https://ipfs.io/ipfs/QmdUYhyvAGqVuM1DwQxsAFH7b9hVe2qnUL4CnmgkjZ4PiS
    console.log('Image uploaded successfully!');
    console.log('IPFS CID:', result.IpfsHash);
  } catch (error) {
    console.error('Error uploading image:', error.message);
  }
}

//uploadImage();   //QmP91vZMKMMeE9pzZBfVGGUeZvGKYJ5p3RLwS9D2M79Jsb

const jsonData = {
  "name": "Certificate",
  "description": "yearly report of data",
  "attributes": [
    {
      "trait_type": "Latitude",
      "value": "40.7128"
    },
    {
      "trait_type": "Longitude",
      "value": "74.0060"
    },
    {
      "trait_type": "Project Address",
      "value": "123 Main Street, New York, NY"
    },
    {
      "trait_type": "Details",
      "value": "This project focuses on environmental sustainability in urban areas."
    },
    {
      "trait_type": "Area",
      "value": 5000
    },
    {
      "trait_type": "NDVI",
      "value": 75
    },
    {
      "trait_type": "Carbon",
      "value": 3500
    },
    {
      "trait_type": "NPAR",
      "value": 200
    },
 
    {
      "trait_type": "PAR",
      "value": 150
    }
  ],
  "image": "https://gateway.pinata.cloud/ipfs/QmP91vZMKMMeE9pzZBfVGGUeZvGKYJ5p3RLwS9D2M79Jsb"
}

//QmPDyqVomXZ7ekkV1dhStxKG9P4pnWxPn61XsEGDsufLNe
//Qma7EcPSmBaUMPGhWXj2gPiipitS7GE542nxuBoEp7SyvX
//https://gateway.pinata.cloud/ipfs/"CID Hash"

//  pinata.pinJSONToIPFS(jsonData).then((result) => {
//     console.log('Successfully uploaded metadata to Pinata!');
//     console.log('IPFS Hash (CID):', result.IpfsHash);
//   }).catch((error) => {
//     console.error('Error uploading metadata to Pinata:', error);
//   });


  // QmRJy5pqVvXiPRVRfi4n46PvWryMSUeeJktx92ghzziRns
  // QmdbtsLP3hLRHQTmRjkNtYVnSTHYCCXkmHBjfzxvMueAGP