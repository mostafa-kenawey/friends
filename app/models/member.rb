class Member < ApplicationRecord
  validates :name, :original_website, presence: true
  validates :original_website, url: true, on: :create
  validates :name, uniqueness: true
  after_create :perform_url_shortener

  def as_json(options={})
    {
      id: id,
      name: name,
      original_website: original_website,
      website: website
    }
  end

  #######
  private
  #######

  def perform_url_shortener
    UrlShortenerJob.perform_later(self.id)
    PageCrawlJob.perform_later(self.id)
  end
end
