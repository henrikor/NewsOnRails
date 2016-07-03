<h1>Listing groups</h1>

<%
   user = Noruser.find(1)
   name = Noruser.login

 -%>
<%= name %>
<table class="articlesliste">
  <tr>


  <% for column in Group.content_columns %>
  <%

if @not_show.include?(column.human_name)
       next
     end
   %>
    <th><%= link_to column.human_name, { :action => "list", :sort => column.name, :order => @order } %>
       <% if column.name == @sort -%>
          <% if @order == "desc" -%>
             <
          <% else -%>
             ^
          <% end %>
       <% end %>
  <% end %>
    </th>
  </tr>

  <% nr = "1" -%>
<% for group in @groups %>
  <tr class="groupslistetr<%= nr -%>">
    <% if nr == "1"
        nr = "0"
       else
        nr = "1"
       end -%>
  <% for column in Group.content_columns %>

  <%
     if @not_show.include?(column.human_name)
       next
     end

    if ((column.human_name == "Created of" || column.human_name == "Updated of") && group.send(column.name) != 0)
    begin
     user = Noruser.find(group.send(column.name))
     name = Noruser.login
      raise "Kunne ikke finne bruker" if !user
    rescue
      if !user
        name = "ingen"
      else
        name = Noruser.login
      end
      flash[:error] = "Kunne ikke finne bruker med id: #{group.send(column.name)}"
    end




  %>
   <td>
    <%=h (name) %></td>
  <% else -%>

    <td>

    <% if column.name == "created_on" || column.name == "updated_on"  -%>
       <%# column.name == column.name -%>
       <%=h group.send(column.name).strftime("%d.%m.%Y kl. %I:%M") %></td>
    <% else -%>
      <%=h group.send(column.name) %></td>
    <% end -%>



  <% end %>
  <% end %>

    <td><%= link_to 'Show', :action => 'show', :id => group %></td>
    <td><%= link_to 'Edit', :action => 'edit', :id => group %></td>

  <% if autorized_to_group?(group.id) -%>
        <% if (group.un_published == 1) %>
   <td><%= button_to 'Publish', :action => 'publish', :id => group %></td>

        <% else %>
   <td><%= button_to 'Un publish', :action => 'un_publish', :id => group %></td>
         <% end %>
   <td><%= button_to 'Destroy', {:action => 'destroy', :id => group}, :confirm => 'Are you sure?' %></td>
   <% end -%>
  </tr>
<% end %>
</table>

<%= link_to 'Previous page', { :page => @group_pages.current.previous, :order => @porder, :sort => @sort } if @group_pages.current.previous %>
<%= pagination_links(@group_pages, :order => @porder, :sort => @sort) %>
<%= link_to 'Next page', { :page => @group_pages.current.next, :order => @porder, :sort => @sort } if @group_pages.current.next %>

<br />

<%= link_to 'New group', :action => 'new' %>
