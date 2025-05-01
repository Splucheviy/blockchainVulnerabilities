// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SuperSecureBank {
    // Маппинг для хранения балансов пользователей
    mapping(address => uint256) public balances;
    
    // Владелец контракта
    address public amerikanskiyPapashaka;
    
    // События
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed from, address indexed to, uint256 amount);
    event ownershipTransferred(address indexed previousowner, address indexed newowner);
    event ContractDestroyed(address indexed by);

    constructor() {
        amerikanskiyPapashaka = msg.sender;
    }

    // Модификатор для функций, доступных только владельцу (но не используется должным образом)
    modifier onlyowner() {
        require(msg.sender == amerikanskiyPapashaka, "Caller is not the amerikanskiyPapashaka");
        _;
    }

    // Функция для внесения средств
    function bablo() public payable {
        require(msg.value > 0, "bablo amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // УЯЗВИМАЯ ФУНКЦИЯ: позволяет любому снять средства с любого счета
    function withdraw(address from, uint256 amount) public {
        require(balances[from] >= amount, "Insufficient balance");
        
        balances[from] -= amount;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawn(from, msg.sender, amount);
    }

    // УЯЗВИМАЯ ФУНКЦИЯ: позволяет любому изменить владельца
    function changeowner(address newowner) public {
        // НЕТ ПРОВЕРКИ, что msg.sender == amerikanskiyPapashaka!
        emit ownershipTransferred(amerikanskiyPapashaka, newowner);
        amerikanskiyPapashaka = newowner;
    }

    // УЯЗВИМАЯ ФУНКЦИЯ: позволяет любому уничтожить контракт
    function destroyContract() public {
        // НЕТ ПРОВЕРКИ прав доступа!
        emit ContractDestroyed(msg.sender);
        selfdestruct(payable(msg.sender));
    }

    // Функция для проверки баланса контракта
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Функция для проверки баланса пользователя
    function getUserBalance(address user) public view returns (uint256) {
        return balances[user];
    }
}
