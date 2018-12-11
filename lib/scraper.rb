require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    html = File.read(index_url)
    students = Nokogiri::HTML(html)

    #important - must use brackets {} to create hash (in addition to do/end) and commas after each key/value pair.

      students.css("div.student-card").collect do |student|

      {
      name: student.css("div.card-text-container h4.student-name").text,
      location: student.css("div.card-text-container p.student-location").text,
      profile_url: student.css("a").attribute("href").value
      }
    end
  end


  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)

    #need to set up a student hash
    student = {}

      #when including "a" after div.social-icon-container - it includes all the links that follow.
      links = profile.css("div.social-icon-container a").collect do |link|
      link.attribute("href").value
      end

      links.each do |link|
        if link.include?("twitter")
          student[:twitter] = link
        elsif link.include?("linkedin")
          student[:linkedin] = link
        elsif link.include?("github")
          student[:github] = link
        else link.include?(".com")
          student[:blog] = link
        end
      end

      student[:profile_quote] = profile.css("div.profile-quote").text
      student[:bio] = profile.css("div.description-holder p").text

  #must return student to create hash
      student
  end


end
