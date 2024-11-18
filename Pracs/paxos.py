import random

class Proposer:
    def __init__(self, proposer_id, acceptors):
        self.proposer_id = proposer_id
        self.proposal_number = 0
        self.value = None
        self.acceptors = acceptors

    def propose(self, value):
        self.proposal_number += 1
        self.value = value
        promises = []
        
        print(f"Proposer {self.proposer_id} proposes value '{value}' with proposal number {self.proposal_number}.")
        
        # Phase 1: Prepare
        for acceptor in self.acceptors:
            promise = acceptor.prepare(self.proposal_number)
            if promise:
                promises.append(promise)

        # Check majority
        if len(promises) > len(self.acceptors) // 2:
            highest_accepted = max(promises, key=lambda p: p[0], default=(0, None))
            if highest_accepted[1] is not None:
                self.value = highest_accepted[1]  # Adopt the highest accepted value
                print(f"Proposer {self.proposer_id} adopts value '{self.value}' from previous accepted proposal.")
            
            # Phase 2: Accept
            for acceptor in self.acceptors:
                acceptor.accept(self.proposal_number, self.value)

class Acceptor:
    def __init__(self, acceptor_id):
        self.acceptor_id = acceptor_id
        self.promised_number = 0
        self.accepted_number = 0
        self.accepted_value = None

    def prepare(self, proposal_number):
        if proposal_number > self.promised_number:
            self.promised_number = proposal_number
            print(f"Acceptor {self.acceptor_id} promises to proposal number {proposal_number}.")
            return self.accepted_number, self.accepted_value
        print(f"Acceptor {self.acceptor_id} rejects proposal number {proposal_number}.")
        return None

    def accept(self, proposal_number, value):
        if proposal_number >= self.promised_number:
            self.promised_number = proposal_number
            self.accepted_number = proposal_number
            self.accepted_value = value
            print(f"Acceptor {self.acceptor_id} accepts proposal number {proposal_number} with value '{value}'.")
        else:
            print(f"Acceptor {self.acceptor_id} rejects proposal number {proposal_number}.")

class Learner:
    def __init__(self, learner_id):
        self.learner_id = learner_id

    def learn(self, value):
        print(f"Learner {self.learner_id} learns the value '{value}'.")

# Simulation
if __name__ == "__main__":
    # Create 3 acceptors
    acceptors = [Acceptor(i) for i in range(3)]

    # Create 1 proposer
    proposer = Proposer(proposer_id=1, acceptors=acceptors)

    # Proposer tries to propose a value
    proposer.propose(value="Value A")
