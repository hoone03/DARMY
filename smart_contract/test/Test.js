const MyToken = artifacts.require("MyToken");

contract("MyToken", (accounts) => {
  let myTokenInstance;

  before(async () => {
    myTokenInstance = await MyToken.deployed();
  });

  it("should display the grade", async () => {
    const grade = await myTokenInstance.fanGrades(accounts[0]);
    console.log("Current Grade:", grade);
  });

  it("should update the grade after check-in 10 times", async () => {
    for (let i = 0; i < 10; i++) {
      await myTokenInstance.checkIn({ from: accounts[0] });
    }
    const grade = await myTokenInstance.fanGrades(accounts[0]);
    console.log("Grade after check-in:", grade);
  });

  it("should update the grade after giving 10 tokens 9 times", async () => {
    for (let i = 0; i < 9; i++) {
      await myTokenInstance.give10tokens({ from: accounts[0] });
    }
    const grade = await myTokenInstance.fanGrades(accounts[0]);
    console.log("Grade after giving 10 tokens:", grade);
  });

  it("should display the total supply after buying premium ticket", async () => {
    await myTokenInstance.buyPremiumTicket({ from: accounts[0] });
    const totalSupply = await myTokenInstance.totalSupply();
    console.log("Total Supply after buying premium ticket:", totalSupply.toString());
  });

  it("should display the permanent and purchase token balances", async () => {
    const permanentBalance = await myTokenInstance.permanentTokenBalances(accounts[0]);
    const purchaseBalance = await myTokenInstance.purchaseTokenBalances(accounts[0]);
    console.log("Permanent Token Balance:", permanentBalance.toString());
    console.log("Purchase Token Balance:", purchaseBalance.toString());
  });

  it("should display the ticket owner based on the total supply", async () => {
    const totalSupply = await myTokenInstance.totalSupply();
    const ticketOwner = await myTokenInstance.getTicketOwner(totalSupply);
    console.log("Ticket Owner:", ticketOwner);
  });

  it("should display the final grade", async () => {
    const grade = await myTokenInstance.fanGrades(accounts[0]);
    console.log("Final Grade:", grade);
  });
});
