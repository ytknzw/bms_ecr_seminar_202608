// Ex9 例 対訳: プール単回帰（体重 ~ ひれ）
// y ~ Normal(intercept + beta_flipper * flipper, sigma)

data {
  int<lower=1> N;
  vector[N] flipper;
  vector[N] y;
}

parameters {
  real intercept;
  real beta_flipper;
  real<lower=0> sigma;
}

model {
  intercept ~ normal(0, 5000);
  beta_flipper ~ normal(0, 20);
  sigma ~ normal(0, 400); // half via <lower=0>

  y ~ normal(intercept + beta_flipper * flipper, sigma);
}
