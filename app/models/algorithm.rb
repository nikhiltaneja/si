module Algorithm
  def rate_shared_skills(shared_skills_count)
    if shared_skills_count == 0
      3
    elsif shared_skills_count > 15
      60
    else  
      shared_skills_count * 4
    end
  end

  def rate_shared_industry_interests(shared_industry_interests_count)
    if shared_industry_interests_count == 0
      2
    elsif shared_industry_interests_count > 4
      20
    else
      shared_industry_interests_count * 5
    end
  end

  def rate_shared_function_interests(shared_function_interests_count)
    if shared_function_interests_count == 0
      2
    elsif shared_function_interests_count > 4
      20
    else
      shared_function_interests_count * 5
    end
  end

  def rate_shared_connections(shared_connections)
    if shared_connections > 1 && shared_connections <= 5
      shared_connections * 3
    elsif shared_connections > 60
      shared_connections
    else
      shared_connections * 2
    end
  end
end
