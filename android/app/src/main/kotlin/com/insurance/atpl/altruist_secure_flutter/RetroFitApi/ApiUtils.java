package com.insurance.atpl.altruist_secure_flutter.RetroFitApi;

public class ApiUtils {

    private ApiUtils() {}

    public static final String BASE_URL = "https://api1.altruistsecure.com/api/";

    public static APIService getAPIService() {

        return RetrofitClient.getClient(BASE_URL).create(APIService.class);
    }

}
