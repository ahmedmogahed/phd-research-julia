module SingleTrackModel
	include("TyreModel.jl")

	using .TyreModel
	using ModelingToolkit

	# Magic Formula
	Ξ(α) = magicFormula(α)
	@register_symbolic Ξ(α)

	export lateralModel
	function lateralModel(;δ, v_x)
		@variables t
		D = Differential(t)

		@mtkmodel BicycleModel begin
		    @parameters begin
		        m = 1555 # mass of the vehicle
		        θ = 2491 # Inertia of the vehicle
		        l_f = 1.354 # length from front tyre to c.g.
		        l_r = 1.372 # length from rear tyre to c.g.
		    end
		    @variables begin
		        p_x(t) 
		        p_y(t)
		        
		        v_y(t)
		        ψ(t)
		        ψd(t)

		        v_xft(t)
		        v_yft(t)
		        α_f(t)
		        α_r(t)
		    end
		    @equations begin
		        m * D(v_y) ~ -m * v_x(t) * D(ψ) + Ξ(α_f) * cos(δ(t)) + Ξ(α_r)

		        D(ψ) ~ ψd
		        θ * D(ψd) ~ l_f * Ξ(α_f) * cos(δ(t)) - l_r * Ξ(α_r)

		        v_xft ~ v_x(t) * cos(δ(t)) + sin(δ(t)) * (v_y + l_f * ψd)
		        v_yft ~ -v_x(t) * sin(δ(t)) + cos(δ(t)) * (v_y + l_f * ψd)
		        α_f ~ -atan(v_yft, v_xft)
		        α_r ~ -atan(v_y - l_r * ψd, v_x(t))

		        # global positions
		        D(p_x) ~ v_x(t) * cos(ψ) - v_y * sin(ψ)
		        D(p_y) ~ v_y * cos(ψ) + v_x(t) * sin(ψ)
		    end
		end

		@mtkbuild lateralModel = BicycleModel()

		return lateralModel
	end
end