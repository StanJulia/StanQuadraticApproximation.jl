using CSV, DataFrames, StanQuap, StanOptimize

ProjDir = @__DIR__

df = CSV.read(joinpath(ProjDir,  "..", "data", "Howell1.csv"), DataFrame)
df = filter(row -> row[:age] >= 18, df);

stan4_1 = "
// Inferring the mean and std
data {
  int N;
  real<lower=0> h[N];
}
parameters {
  real<lower=0> sigma;
  real<lower=0,upper=250> mu;
}
model {
  // Priors for mu and sigma
  mu ~ normal(178, 20);
  sigma ~ uniform(0 , 50);

  // Observed heights
  h ~ normal(mu, sigma);
}
";

data = (N = size(df, 1), h = df.height)
init = (mu = 178.0, sigma = 25.0)

qm, sm, om = quap("s4.1s", stan4_1; data, init)
qm |> display