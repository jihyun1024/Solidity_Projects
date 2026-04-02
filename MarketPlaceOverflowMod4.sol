pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod4 {
	address public owner;
	uint public stockQuantity;	// 재고 수
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// 추가 재고 수를 출력하는 이벤트
	event AddStock(uint _addedQuantity);
			
	/// 생성자
	function MarketPlaceOverflowMod4() {
		owner = msg.sender;
		stockQuantity = 0;
	}
	
	/// 재고를 추가하는 처리
	function addStock(uint _addedQuantity) public onlyOwner {
		// 재고 수 확인
		require(stockQuantity + _addedQuantity > stockQuantity);
		
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}
