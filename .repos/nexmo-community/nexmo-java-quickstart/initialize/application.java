AuthMethod auth = new JWTAuthMethod(
        NEXMO_APPLICATION_ID,
        FileSystems.getDefault().getPath(NEXMO_APPLICATION_PRIVATE_KEY)
);
NexmoClient client = new NexmoClient(auth);
