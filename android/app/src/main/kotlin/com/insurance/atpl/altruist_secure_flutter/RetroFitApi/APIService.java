package com.insurance.atpl.altruist_secure_flutter.RetroFitApi;

import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Url;

public interface APIService {
    @GET
    Call<DamageScreenStatus> damageScreenApi(@Url String url);

}
