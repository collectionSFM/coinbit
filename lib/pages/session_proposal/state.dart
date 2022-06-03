class SessionProposalState {
  Map ? sessionPropose;
  Map ? approvedAccounts;
  List approvedWallet = [];

  get enableApprove {
    var enabled = false;
    if (approvedAccounts != null) {
      approvedAccounts?.forEach((key, value) {
        if (value.length > 0) {
          enabled = true;
          return;
        }
      });
    }
    return enabled;
  }
}
