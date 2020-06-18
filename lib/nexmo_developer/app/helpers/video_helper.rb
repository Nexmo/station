module VideoHelper
  def video_embed_url(video_url)
    if video_url.include? 'youtube'
      video_id = video_url.match(/v=(.{11})/)[1]
      return "https://www.youtube.com/embed/#{video_id}?showinfo=0"
    end

    if video_url.include? 'vimeo'
      video_id = video_url.match(/(\d{7,})/)[1]
      return "https://player.vimeo.com/video/#{video_id}"
    end

    video_url
  end

  def featured_video
    # Any of the latest 3 videos can be "featured"
    Session.where(published: true).order(created_at: 'desc').limit(3).sample
  end
end
