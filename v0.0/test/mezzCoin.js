const MezzCoin = artifacts.require('MezzCoin');

contract('MezzCoin', (accounts) => {
  it('should put 10000 MezzCoin in the first account', async () => {
    const mezzCoinInstance = await MezzCoin.deployed();
    const balance = await mezzCoinInstance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  it('should call a function that depends on a linked library', async () => {
    const mezzCoinInstance = await MezzCoin.deployed();
    const mezzCoinBalance = (
      await mezzCoinInstance.getBalance.call(accounts[0])
    ).toNumber();
    const mezzCoinEthBalance = (
      await mezzCoinInstance.getBalanceInEth.call(accounts[0])
    ).toNumber();

    assert.equal(
      mezzCoinEthBalance,
      2 * mezzCoinBalance,
      'Library function returned unexpected function, linkage may be broken'
    );
  });
  it('should send coin correctly', async () => {
    const mezzCoinInstance = await MezzCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (
      await mezzCoinInstance.getBalance.call(accountOne)
    ).toNumber();
    const accountTwoStartingBalance = (
      await mezzCoinInstance.getBalance.call(accountTwo)
    ).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await mezzCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (
      await mezzCoinInstance.getBalance.call(accountOne)
    ).toNumber();
    const accountTwoEndingBalance = (
      await mezzCoinInstance.getBalance.call(accountTwo)
    ).toNumber();

    assert.equal(
      accountOneEndingBalance,
      accountOneStartingBalance - amount,
      "Amount wasn't correctly taken from the sender"
    );
    assert.equal(
      accountTwoEndingBalance,
      accountTwoStartingBalance + amount,
      "Amount wasn't correctly sent to the receiver"
    );
  });
});
