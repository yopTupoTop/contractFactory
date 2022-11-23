const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

const BASE_URI1 = "http://test1/";
const BASE_URI2 = "http://test2/";

describe("factory test", () => {
    let ContractFactory;
    let contractFactory;

    let My721;

    beforeEach(async () => {
        ContractFactory = await ethers.getContractFactory("ContractFactory");
        contractFactory = await ContractFactory.deploy(BASE_URI1, BASE_URI2);
        await contractFactory.deployed();

        My721 = await ethers.getContractFactory("My721");

        [owner, address1] = await ethers.getSigners();

    });

    it("", async () => {
        let addr = await contractFactory.connect(owner).deployERC721();
        let result = await addr.wait();
        console.log(result);
        let add = result.events[1].args.contractAddress;
        console.log(add);
        expect(ethers.utils.isAddress(add)).eql(true);
        //let token = await contractFactory.attach(add);
        await contractFactory.connect(owner).mintERC721(0);
        let token = My721.attach(add);
        expect(await token.balanceOf(owner.address)).eql(ethers.BigNumber.from(1));
        console.log(token);
    })
    
});