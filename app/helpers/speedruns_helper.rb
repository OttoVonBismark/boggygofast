module SpeedrunsHelper
    def categorize_runs(rcid)
        return Speedrun.where('runcat_id == ?', rcid).to_a
    end
end
