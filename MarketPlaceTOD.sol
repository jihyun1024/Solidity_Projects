pragma solidity ^0.4.11;
contract MarketPlaceTOD {
	address public owner;
	uint public price;	// 단가
	uint public stockQuantity;	// 재고 수
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	event UpdatePrice(uint _price);
	event Buy(uint _price, uint _quantity, uint _value, uint _change);
	
	/// 생성자
	function MarketPlaceTOD() {
		owner = msg.sender;
		price = 1;
		stockQuantity = 100;
	}
	
	/// 단가 업데이트
	function updatePrice(uint _price) public onlyOwner {
		price = _price;
		UpdatePrice(price);
	}

	/// 구매 처리
	function buy(uint _quantity) public payable {
		if (msg.value < _quantity * price || _quantity > stockQuantity) {
			throw;
		}
		
		// 거스름돈 송금
		if(!msg.sender.send(msg.value - _quantity * price)) {
			throw;	
		}
		
		stockQuantity -= _quantity;
		Buy(price, _quantity, msg.value, msg.value - _quantity * price);
	}	
}
