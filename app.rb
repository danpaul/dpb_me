$LOAD_PATH << './lib/blume/lib'

require 'blume'
require 'haml'
require 'sinatra'

$MEDIA_ROOT = 'https://googledrive.com/host/0B4qKq8es2-_-LXNFcDQ4b3JqalU/art'
$THUMB_ROOT = 'https://googledrive.com/host/0B4qKq8es2-_-LXNFcDQ4b3JqalU/art/thumbs_250'

def media_url ext
	return '"' + $MEDIA_ROOT + ext + '"'
end

def thumb_url ext
	return '"' + $MEDIA_ROOT + '/thumbs_250' + ext + '"'
end

configure do
	$blume = Blume.new
	$content = $blume.build_content
	$post_tags = $blume.get_tags('posts')
end

get '/generate_site' do
	$blume.generate_site
end

get '/' do
	@posts = $content['posts']
	@tags = $post_tags
	haml :index
end

get '/tag/:tag/' do
	@posts = $blume.get_posts_with_tag(params[:tag])
	@tags = $post_tags
	haml :index
end

get '/page/:page/' do
	@post = $content['pages'].detect{|i| i['title'] == params[:page]}
	@tags = $post_tags
	haml :single_page
end

get '/:date_title/' do
	@post = $content['posts'].detect{|i| i['date_title'] == params[:date_title]}
	@tags = $post_tags
	haml :single_page
end

__END__

@@layout
%html
	%script{src: '/js/vendor/custom.modernizr.js'}
	%script{src: '/js/vendor/jquery.js'}
	%link{rel: 'stylesheet', href: '/css/foundation.min.css'}
	%body
		=haml :menu
		.row
			.column.large-centered#content
				:javascript
					$("#content").hide();
				=yield
		%script{src: '/js/foundation.min.js'}
		:javascript
			$(document).foundation();
			$(window).load(function(){
				$('#content').fadeIn();
			});

@@single_page
.large-6.large-centered.columns
	-if @post['slide_images']
		-@post['slide_images'].each do |image|
			%p
				%img{src: "#{$MEDIA_ROOT + image}"}
	-if @post['slide_videos']
		-@post['slide_videos'].each do |video|
			.flex-video.vimeo
				%iframe{src: "#{video}"}

	.content= @post['body']
	-if @post['footer_images']
		-@post['footer_images'].each do |image|
			%p
				%img{src: "#{$MEDIA_ROOT + image}"}

@@index
%ul.large-block-grid-6.small-block-grid-2.centered
	-@posts.each do |post|
		%li
			.little-box
				%a{href: "/#{post['date_title']}/"}
					-if post['featured_images']
						-post['featured_images'].each do |image_path|
							%p
								%img{src: "#{$THUMB_ROOT + image_path}", width: "100%"}
					-elsif post['featured_video']
						.flex-video.vimeo
							%iframe{src: "#{post['featured_video']}"}
					-if post['placard']
						%a{href: "/#{post['date_title']}/"}
							= post['placard']

@@menu
%nav.top-bar
  %ul.title-area
    / Title Area
    %li.name
      %h1
        %a{:href => "/"} dan breczinski [dpb.me]
    %li.toggle-topbar.menu-icon
      %a{href: "/"}
        %span Menu
  %section.top-bar-section
    / Left Nav Section
    %ul.left
      %li.divider
      %li.has-dropdown
        %a{:href => "/"} art
        %ul.dropdown
          -@tags.sort.each do |t|
            %li
              %a{:href => '/tag/' + t + '/'}
                = t
            %li.divider
      %li.divider
      %li
        %a{:href => "https://github.com/danpaul?tab=repositories"} code
      %li.divider
    / Right Nav Section
    %ul.right
      %li.divider
      %li
        %a{:href => "/page/about/"} about
      %li.divider
      %li
        %a{:href => "/page/contact/"} contact
      %li.divider
