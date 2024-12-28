class Proposal
{
  String? UserProposal;
  // String? name;
  // String? phoneNumber;
  // String? email;
  // String? stateCountry;
  // String? completeContractProposal;


  Proposal({
    this.UserProposal,
    // this.name,
    // this.phoneNumber,
    // this.email,
    // this.stateCountry,
    // this.completeContractProposal,
  });

  Proposal.fromJson(Map<String, dynamic> json)
  {
    UserProposal=json['UserProposal'];
    //name = json['name'];
    // phoneNumber = json['phoneNumber'];
    // email = json['email'];
    // stateCountry = json['stateCountry'];
    // completeContractProposal = json['completeContractProposal'];
  }
}