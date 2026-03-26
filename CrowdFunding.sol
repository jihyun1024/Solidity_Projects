//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.4.11;
contract CrowdFunding {
	// 투자자 구조체
	struct Investor {
		address addr;	// 투자자의 어드레스
		uint amount;	// 투자액
	}
	
	address public owner;		// 컨트랙트 소유자
	uint public numInvestors;	// 투자자 수
	uint public deadline;		// 마감일 (UnixTime)
	string public status;		// 모금활동 스테이터스
	bool public ended;			// 모금 종료 여부
	uint public goalAmount;		// 목표액
	uint public totalAmount;	// 총 투자액
	mapping (uint => Investor) public investors;	// 투자자 관리를 위한 매핑
	
	modifier onlyOwner () {
		require(msg.sender == owner);
		_;
	}
	
	/// 생성자
	constructor (uint _duration, uint _goalAmount) {
		owner = msg.sender;

		// 마감일 설정 (Unixtime) = 현재 시간 + 원하는 만큼의 기간
		deadline = block.timestamp + _duration;

		goalAmount = _goalAmount;
		status = "Funding";
		ended = false;

		numInvestors = 0;
		totalAmount = 0;
	}
	
	/// 투자 시에 호출되는 함수
	/// public: 누군가 이 함수를 호출 가능, payable: 지불 가능
	function fund() public payable {
		// 모금이 끝났다면 처리 중단
		require(!ended);
		
		Investor storage inv = investors[numInvestors++];
		inv.addr = msg.sender;
		inv.amount = msg.value;
		totalAmount += inv.amount;
	}
	
	// 목표액 달성 여부 확인
	// 그리고 모금 성공/실패 여부에 따라 송금
	function checkGoalReached () public onlyOwner {		
		// 모금이 끝났다면 처리 중단
		require(!ended);
		
		// 마감이 지나지 않았다면 처리 중단
		require(block.timestamp >= deadline);
		
		if(totalAmount >= goalAmount) { // 모금 성공인 경우
			status = "Campaign Succeeded";
			ended = true;
			// 컨트랙트 소유자에게 컨트랙트에 있는 모든 이더를 송금
			(bool success, ) = payable(owner).call{value: address(this).balance} ("");
			if(!success) {
				revert();
			}
		} else {	// 모금 실패인 경우
			uint i = 0;
			status = "Campaign Failed";
			ended = true;
			
			// 각 투자자에게 투자금을 돌려줌
			while(i <= numInvestors) {
				(bool success, ) = payable(investors[i].addr).call{value: investors[i].amount} ("");
				if (!success) {
					revert();
				}
				i++;
			}
		}
	}
	
	/// balance 변수 확인 코드
	function getBalance() view public returns(uint) {
		return address(this).balance;
	}

	/// 컨트랙트를 소멸시키기 위한 함수
	function kill() public onlyOwner {
		//selfdestruct(owner);
	}
}
