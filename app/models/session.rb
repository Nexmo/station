class Session < ApplicationRecord
  belongs_to :event

  validates :title, presence: true
  validates :author, presence: true
  validates :event, presence: true
  validates :video_url, presence: true

  def video_content
    video_id = video_url.gsub('https://www.youtube.com/watch?v=', '')
    <<~HEREDOC
      <div class="video">
        <iframe src="https://www.youtube.com/embed/#{video_id}?showinfo=0" frameborder="0" allowfullscreen></iframe>
      </div>
    HEREDOC
  end
end
