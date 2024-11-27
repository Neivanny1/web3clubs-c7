// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ProposalContract is Ownable {
    uint256 private counter;

    struct Proposal {
        string title;
        string description;
        uint256 approve;
        uint256 reject;
        uint256 pass;
        uint256 total_vote_to_end;
        bool current_state;
        bool is_active;
    }

    mapping(uint256 => Proposal) private proposal_history;
    address[] private voted_addresses;

    event ProposalCreated(uint256 indexed id, string title);
    event Voted(address indexed voter, uint8 choice);
    event ProposalTerminated(uint256 indexed id);

    constructor(address initialOwner) Ownable(initialOwner) {}

    modifier active() {
        require(proposal_history[counter].is_active, "Proposal is not active");
        _;
    }

    modifier newVoter(address _address) {
        require(!isVoted(_address), "Address has already voted");
        _;
    }

    function create(string calldata _title, string calldata _description, uint256 _total_vote_to_end) external onlyOwner {
        counter += 1;
        proposal_history[counter] = Proposal(_title, _description, 0, 0, 0, _total_vote_to_end, false, true);
        emit ProposalCreated(counter, _title);
    }

    function vote(uint8 choice) external active newVoter(msg.sender) {
        require(choice <= 2, "Invalid vote choice");

        Proposal storage proposal = proposal_history[counter];
        uint256 total_vote = proposal.approve + proposal.reject + proposal.pass;

        voted_addresses.push(msg.sender);

        if (choice == 1) {
            proposal.approve += 1;
        } else if (choice == 2) {
            proposal.reject += 1;
        } else {
            proposal.pass += 1;
        }

        proposal.current_state = calculateCurrentState();

        if ((proposal.total_vote_to_end - total_vote == 1)) {
            proposal.is_active = false;
            resetVoters();
        }

        emit Voted(msg.sender, choice);
    }

    function terminateProposal() external onlyOwner active {
        proposal_history[counter].is_active = false;
        resetVoters();
        emit ProposalTerminated(counter);
    }

    function calculateCurrentState() private view returns (bool) {
        Proposal storage proposal = proposal_history[counter];
        uint256 totalVotes = proposal.approve + proposal.reject + proposal.pass;

        if (totalVotes == 0) return false;

        if ((proposal.approve * 100) / totalVotes > 60) return true;
        if ((proposal.reject * 100) / totalVotes > 40) return false;

        return proposal.pass % 2 == 0;
    }

    function resetVoters() private {
        voted_addresses = [owner()];
    }

    function isVoted(address _address) private view returns (bool) {
        for (uint256 i = 0; i < voted_addresses.length; i++) {
            if (voted_addresses[i] == _address) return true;
        }
        return false;
    }

    function getCurrentProposal() external view returns (Proposal memory) {
        return proposal_history[counter];
    }

    function getProposal(uint256 number) external view returns (Proposal memory) {
        return proposal_history[number];
    }

    function getVotedAddresses() external view returns (address[] memory) {
        return voted_addresses;
    }
}
