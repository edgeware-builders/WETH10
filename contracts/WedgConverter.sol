// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2015, 2016, 2017 Dapphub
// Adapted by Ethereum Community 2020
pragma solidity 0.7.6;


interface WEDG9Like {
    function withdraw(uint) external payable;
    function deposit() external payable;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
}

interface WEDG10Like {
    function depositTo(address) external payable;
    function withdrawFrom(address, address, uint256) external payable;
}

contract WedgConverter {

    receive() external payable {
    }

    function wedg9ToWedg10(WEDG9Like wedg9, WEDG10Like wedg10, address account, uint256 value) public {
        wedg9.transferFrom(account, address(this), value);
        wedg9.withdraw(value);
        wedg10.depositTo{ value: value }(account);
    }

    function wedg10ToWedg9(WEDG9Like wedg9, WEDG10Like wedg10, address account, uint256 value) public {
        wedg10.withdrawFrom(account, address(this), value);
        wedg9.deposit{ value: value }();
        wedg9.transfer(account, value);
    }
}

