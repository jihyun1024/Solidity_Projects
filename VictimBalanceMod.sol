pragma solidity ^0.4.11;
contract  VictimBalance {
	// 어드레스 별로 잔고를 관리
  mapping (address => uint) public userBalances;

	// 메시지를 출력하기 위한 이벤트
	event MessageLog(string);
	
	// 잔고를 출력하기 위한 이벤트
	event BalanceLog(uint);

	/// 생성자
	function VictimBalance() {
	}

	/// 송금받을 때 호출되는 함수
	function addToBalance() public payable {
		userBalances[msg.sender] += msg.value;
	}

	/// 이더를 인출할 때 호출되는 함수
	function withdrawBalance() public payable returns(bool) {
		MessageLog("withdrawBalance started.");
		BalanceLog(this.balance);
		
		// 1 잔고를 확인
		if(userBalances[msg.sender] == 0) {
			MessageLog("No Balance.");
			return false;
		}

		// 2 잔고를 업데이트 하기 전에 송금할 금액 계산
		uint amount = userBalances[msg.sender];				

		// 3 잔고 업데이트
		userBalances[msg.sender] = 0;
		
		// 4 자신을 호출한 어드레스로 이더 반환
		if (!(msg.sender.call.value(amount)())) { throw; }
		
		MessageLog("withdrawBalance finished.");
		
		return true;
	}
}
