<div class="heading">
	<br>
	<% ['name', 'email','website'].each do |entry| %>
		<% unless @data[entry].nil? %>
			<div class="row"><div class="<%= entry %> text-center"><%= @data[entry]['desc'] %>
				<%- unless @data[entry]['link'].nil? -%><a href="<%= @data[entry]['link'] %>"><%- end -%>
				<%- if entry == 'email' -%>
					<%= @data[entry]['value'].gsub('@', ' [at] ') %>
				<%- else -%>
					<%= @data[entry]['value'] %>
				<%- end %>
				<%- unless @data[entry]['link'].nil? -%></a><%- end -%>
			</div></div>
		<% end %>
	<% end %>
</div>
<br>
<div class=""><div class="summary"><span class="title"><%= @data['summary']['title'] %></span><span class="content"><%= @data['summary']['content'] %></span></div></div>
<div class=""><div class="skills"><span class="title"><%= @data['skills']['title'] %></span><span class="content"><%= @data['skills']['content'] %></span></div></div>
<br>
<div class="experience"><div class="title">Professional Experience</div><br>
<% @data['experience'].each do |entry| %>
<div class="entry">
	<div class="header">
		<span class="dates"><%= entry['dates'] %></span>
		<span class="title"><%= entry['title'] %>,</span>
		<span class="company"><%= entry['company'] %>,</span>
		<span class="location"><%= entry['location'] %><span class="extra"> <%= entry['extra'] %></span></span>
	</div>
	<% unless entry['responsibilities'].nil? %>
		<ul class="responsibilities">
		<% entry['responsibilities'].each do |response| %>
			<li class="entry"><%= response %></li>
		<% end %>
		</ul>
	<% else %>
		<br>
	<% end %>
</div>
<% end %>
</div>
<% unless @data['education'].nil? %>
	<div class="education">
	<div class="title">Education</div>
	<% @data['education'].each do |edu| %>
		<div class="entry"><span class="name"><%= edu['name'] %></span>, <%= edu['grad_date'] %></div>
		<div class="entry"><%= edu['degree'] %></div>
	<% end %>
	</div>
<% end %>
<br>
<br>