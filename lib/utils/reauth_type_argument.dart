enum SensitiveOperationType {
  DELETE_ACCOUNT,
}

class ReauthTypeArgument {
  final SensitiveOperationType type;

  ReauthTypeArgument(this.type);
}
