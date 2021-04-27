// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.6;
import "../WEDG10.sol";


/// @dev A contract that will receive wedg, and allows for it to be retrieved.
contract MockHolder {
    constructor (address payable wedg, address retriever) {
        WEDG10(wedg).approve(retriever, type(uint).max);
    }
}

/// @dev Invariant testing
contract WEDG10Fuzzing {

    WEDG10 internal wedg;
    address internal holder;

    /// @dev Instantiate the WEDG10 contract, and a holder address that will return wedg when asked to.
    constructor () {
        wedg = new WEDG10();
        holder = address(new MockHolder(address(wedg), address(this)));
    }

    /// @dev Receive ETH when withdrawing.
    receive () external payable { }

    /// @dev Add two numbers, but return 0 on overflow
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        assert(c >= a); // Normally it would be a `require`, but we want the test to fail if there is an overflow, not to be ignored.
    }

    /// @dev Subtract two numbers, but return 0 on overflow
    function sub(uint a, uint b) internal pure returns (uint c) {
        c = a - b;
        assert(c <= a); // Normally it would be a `require`, but we want the test to fail if there is an overflow, not to be ignored.
    }

    /// @dev Test that supply and balance hold on deposit.
    function deposit(uint ethAmount) public {
        uint supply = address(wedg).balance;
        uint balance = wedg.balanceOf(address(this));
        wedg.deposit{value: ethAmount}(); // It seems that echidna won't let the total value sent go over type(uint256).max
        assert(address(wedg).balance == add(supply, ethAmount));
        assert(wedg.balanceOf(address(this)) == add(balance, ethAmount));
        assert(address(wedg).balance == address(wedg).balance);
    }

    /// @dev Test that supply and balance hold on withdraw.
    function withdraw(uint ethAmount) public {
        uint supply = address(wedg).balance;
        uint balance = wedg.balanceOf(address(this));
        wedg.withdraw(ethAmount);
        assert(address(wedg).balance == sub(supply, ethAmount));
        assert(wedg.balanceOf(address(this)) == sub(balance, ethAmount));
        assert(address(wedg).balance == address(wedg).balance);
    }

    /// @dev Test that supply and balance hold on transfer.
    function transfer(uint ethAmount) public {
        uint thisBalance = wedg.balanceOf(address(this));
        uint holderBalance = wedg.balanceOf(holder);
        wedg.transfer(holder, ethAmount);
        assert(wedg.balanceOf(address(this)) == sub(thisBalance, ethAmount));
        assert(wedg.balanceOf(holder) == add(holderBalance, ethAmount));
        assert(address(wedg).balance == address(wedg).balance);
    }

    /// @dev Test that supply and balance hold on transferFrom.
    function transferFrom(uint ethAmount) public {
        uint thisBalance = wedg.balanceOf(address(this));
        uint holderBalance = wedg.balanceOf(holder);
        wedg.transferFrom(holder, address(this), ethAmount);
        assert(wedg.balanceOf(address(this)) == add(thisBalance, ethAmount));
        assert(wedg.balanceOf(holder) == sub(holderBalance, ethAmount));
        assert(address(wedg).balance == address(wedg).balance);
    }
}