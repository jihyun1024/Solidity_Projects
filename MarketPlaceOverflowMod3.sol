pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod3 {
	address public owner;
	uint8 public stockQuantity;	// 재고 수
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// 추가 재고 수를 출력하는 이벤트
	event AddStock(uint _addedQuantity);
			
	/// 생성자
	function MarketPlaceOverflowMod3() {
		owner = msg.sender;
		stockQuantity = 100;
	}
	
	/// 재고를 추가하는 처리
	function addStock(uint _addedQuantity) public onlyOwner {  // 수정된 부분
		// 재고 수 확인
		require(_addedQuantity < 256);
		
		// 오버플로우 확인
		require(stockQuantity + uint8(_addedQuantity) > stockQuantity);
		
		AddStock(_addedQuantity);
		stockQuantity += uint8(_addedQuantity);
	}
}
