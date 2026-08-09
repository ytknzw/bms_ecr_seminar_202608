// Ex9 例 対訳: 階層回帰（体重 ~ ひれ、種差つき切片・傾き）

data {
  int<lower=1> N;
  int<lower=1> S;
  array[N] int<lower=1, upper=S> species;
  vector[N] flipper;
  vector[N] y;
}

parameters {
  real intercept_all;
  real beta_flipper_all;
  real<lower=0> sigma_intercept;
  real<lower=0> sigma_flipper;
  vector[S] intercept;
  vector[S] beta_flipper;
  real<lower=0> sigma_y;
}

model {
  intercept_all ~ normal(0, 5000);
  beta_flipper_all ~ normal(0, 20);
  sigma_intercept ~ normal(0, 1000); // half via <lower=0>
  sigma_flipper ~ normal(0, 10);
  intercept ~ normal(intercept_all, sigma_intercept);
  beta_flipper ~ normal(beta_flipper_all, sigma_flipper);
  sigma_y ~ normal(0, 400);

  for (n in 1:N) {
    y[n] ~ normal(
      intercept[species[n]] + beta_flipper[species[n]] * flipper[n],
      sigma_y
    );
  }
}
