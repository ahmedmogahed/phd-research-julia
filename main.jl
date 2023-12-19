include("models/SingleTrackModel.jl")
include("models/TyreModel.jl")

using DifferentialEquations, Plots
using .SingleTrackModel, .TyreModel

model = lateralModel(δ = t -> deg2rad(10), v_x = t -> 10)

prob = ODEProblem(model, [model.p_x => 0, model.p_y => 0, model.v_y => 0, model.ψ => 0, model.ψd => 0], (0.0, 100.0))
sol = solve(prob)

println(sol(10))

# p = plot(sol, idxs = (4,5))
# savefig(p,"plots/plot.pdf")