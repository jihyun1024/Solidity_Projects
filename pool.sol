// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.4.11;
contract pool {
    // 참여자 구조체
    struct Player {
        address addr;
    }

    address public owner; // 컨트랙트 소유자
    uint public totalAmounts; // 총 베팅액
    uint public numOfPlayers; // 참가자 수
    string public betStatus; // 베팅 참가 가능 여부
    bool public ended; // 종료 여부

    // 매핑
    mapping(uint => Player) public players;

    // 소유자만 실행 가능하도록 제어
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // 생성자: 컨트랙트 배포 시 배포자를 소유자로 설정
    constructor() {
        owner = msg.sender;
        totalAmounts = 0;
        numOfPlayers = 0;
        betStatus = "Betting";
        ended = false;
    }

    function bet() public payable {
        require(!ended);
        require(msg.value == 1000000000000000000); // 1 ETH 베팅

        Player storage p = players[numOfPlayers++];
        p.addr = msg.sender;
        totalAmounts += msg.value; // 전체 잔액에 1 ETH만큼 추가
    }

    function random() private view returns (uint) {
        // 현재 블록의 정보와 상태로 해시값을 만들고 이를 숫자로 변환해 
        // Pseudo-random 값을 제작
        return uint(
            keccak256(
                abi.encodePacked(
                    block.timestamp, // 블록 생성 시간 
                    block.prevrandao, // 이전 블록의 랜덤값
                    numOfPlayers // 현재 참여자 수
                )
            )
        );
    }

    function draw() public onlyOwner {
        require(!ended);
        require(numOfPlayers > 0); // 베팅 참가자가 1명 이상 있어야 함

        // random 함수로 베팅 winner 선정
        uint index = random() % numOfPlayers;
        address winner = players[index].addr; 

        // 상금 분배
        uint winnerAmount = (totalAmounts * 90) / 100;
        uint ownerAmount = totalAmounts - winnerAmount;

        // 당첨자에게 90% 송금
        (bool success1, ) = payable(winner).call{value: winnerAmount} ("");
        if (!success1) {
            revert();
        }

        // owner에게 10% 송금
        (bool success2, ) = payable(owner).call{value: ownerAmount} ("");
        if (!success2) {
            revert();
        }

        // 사용자 목록 전체 삭제
        uint i = 0;
        while (i < numOfPlayers) {
            delete players[i];
            i++;
        }
        // 상태 초기화
        betStatus = "Finished";
        ended = true;
        numOfPlayers = 0;
        totalAmounts = 0;
    }
}
