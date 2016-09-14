require_relative "../lib/district_repository"

class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    @district_repo

end

end
