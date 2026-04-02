pragma solidity ^0.4.11;
contract MarketPlaceOverflow {
	address public owner;
	uint8 public stockQuantity;	// 재고 수
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// 추가 재고 수를 출력하는 이벤트
	event AddStock(uint _addedQuantity);
			
	/// 생성자
	function MarketPlaceOverflow() {
		owner = msg.sender;
		stockQuantity = 100;
	}
	
	/// 재고를 추가하는 처리
	function addStock(uint8 _addedQuantity) public onlyOwner {
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}
