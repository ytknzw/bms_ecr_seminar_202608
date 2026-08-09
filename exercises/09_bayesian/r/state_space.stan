// Ex9 Stretch 対訳: 種別ローカルレベル状態空間（Species × year の Body_Mass 平均）
// level[s,t] = mu0[s] + cumulative_sum(innov[s,]) * sigma_level
// 事前は Python HalfNormal に合わせて truncated normal（lower=0）

data {
  int<lower=1> S;
  int<lower=1> T;
  int<lower=1> N;
  array[N] int<lower=1, upper=S> species;
  array[N] int<lower=1, upper=T> time;
  vector[N] y;
}

parameters {
  vector[S] mu0;
  real<lower=0> sigma_level;
  real<lower=0> sigma_obs;
  matrix[S, T] innov;
}

transformed parameters {
  matrix[S, T] level;
  for (s in 1:S) {
    level[s] = (mu0[s] + cumulative_sum(to_vector(innov[s])) * sigma_level)';
  }
}

model {
  mu0 ~ normal(4000, 500);
  sigma_level ~ normal(0, 100); // half via <lower=0> ≒ HalfNormal(100)
  sigma_obs ~ normal(0, 200);   // half via <lower=0> ≒ HalfNormal(200)
  to_vector(innov) ~ normal(0, 1);
  for (n in 1:N) {
    y[n] ~ normal(level[species[n], time[n]], sigma_obs);
  }
}
