const { expect } = require("chai");
const { ethers } = require("hardhat");

const BASE_URI = "http://test/";

describe("ERC721 factory test", () => {
    let ContractFactory;
    let contractFactory;

    let My721;

    beforeEach(async () => {
        ContractFactory = await ethers.getContractFactory("ERC721ContractFactory");
        contractFactory = await ContractFactory.deploy(BASE_URI);
        await contractFactory.deployed();

        My721 = await ethers.getContractFactory("My721");

        [owner, address1] = await ethers.getSigners();

    });

    it("succesful deploy and mint", async () => {
        let contract = await contractFactory.connect(owner).deployERC721();
        //get information about transaction
        let result = await contract.wait();
        console.log(result);
        //get arguement from event with index 1
        let add = result.events[1].args.contractAddress;
        console.log(add);
        expect(ethers.utils.isAddress(add)).eql(true);
        
        await contractFactory.connect(owner).mintERC721(0);
        //Returns a new instance of the Contract attached to a new address
        let token = My721.attach(add);
        expect(await token.balanceOf(owner.address)).eql(ethers.BigNumber.from(1));
        console.log(token);
    });

    it("try to deploy from not owner address", async () => {
        await expect(contractFactory.connect(address1).deployERC721()).revertedWith("Ownable: caller is not the owner");
    });

    it("try to mint from not owner address", async () => {
        await contractFactory.connect(owner).deployERC721();
        await expect(contractFactory.connect(address1).mintERC721(0)).revertedWith("Ownable: caller is not the owner");
    });
    
});