const { expect } = require("chai");
const { ethers } = require("hardhat");

const BASE_URI = "http://test/";

describe("ERC1155 factory test", () => {
    let ContractFactory;
    let contractFactory;

    let My1155;

    beforeEach(async () => {
        ContractFactory = await ethers.getContractFactory("ERC1155ContractFactory");
        contractFactory = await ContractFactory.deploy(BASE_URI);
        await contractFactory.deployed();

        My1155 = await ethers.getContractFactory("My1155");

        [owner, address1] = await ethers.getSigners();

    });

    it("succesful deploy and mint", async () => {
        let contract = await contractFactory.connect(owner).deployERC1155();
        let result = await contract.wait();
        let add = result.events[1].args.contractAddress;
        console.log(add);
        expect(ethers.utils.isAddress(add)).eql(true);

        await contractFactory.connect(owner).mintERC1155(0, 1001, 3);
        let token = My1155.attach(add);
        expect(await token.balanceOf(owner.address, 1001)).eql(ethers.BigNumber.from(3));
        console.log(token);
    });

    it("try to deploy from not owner address", async () => {
        await expect(contractFactory.connect(address1).deployERC1155()).revertedWith("Ownable: caller is not the owner");
    });

    it("try to mint from not owner address", async () => {
        await contractFactory.connect(owner).deployERC1155();
        await expect(contractFactory.connect(address1).mintERC1155(0, 1001, 3)).revertedWith("Ownable: caller is not the owner");
    });

});
