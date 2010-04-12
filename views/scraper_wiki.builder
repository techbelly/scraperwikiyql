xml.table(:xmlns => 'http://query.yahooapis.com/v1/schema/table.xsd') { |t|
  t.meta { |m|
    m.author("Scraper wiki YQL bindings")
    m.documentationUrl("None")
    m.description("Autogenerated table for scraper_wiki #{name}.")
    m.sampleQuery("SELECT * FROM {table} WHERE #{keys.first}='something' AND sw_api_key='YOUR_API_KEY'")
  }
  t.bindings {|b|
    b.select(:itemPath=>'result.entries',:produces=>'JSON') { |s|
       s.urls { |u|
         u.url('http://api.scraperwiki.com/api/1.0/datastore/search')
       }
       s.paging(:model=>'offset')  { |p|
         p.start(:id=>'offset',:default=>'0')
         p.pagesize(:id=>'limit',:max=>'100')
       }
       s.inputs { |i|
         i.key(:id=>'key',:as=>'sw_api_key',:type=>'xs:string',:paramType=>'query',:required=>'true')
         keys.each do |key|
           i.key(:id=>key,:type=>'xs:string',:type=>'xs:string',:paramType=>'variable')
         end
       }
       jscript_keys = keys.map do |key|
         %$if (#{key}) { params.push("#{key},"+#{key}); }$
       end.join("\n")
       s.execute { |e|
         jscript = %$request.query("name","#{name}");
         request.query("format","json");
         var params = [];
         #{jscript_keys}
         request.query("filter",params.join("|"));       
         try { 
            var tb = request.get().response;
            var tbl = eval(tb);
            response.object =  { 'entries': tbl};
          } catch(err) {
            response.object =  {'result':'failure', 'error': err};
          }$
         e.cdata!(jscript)
      }
    }
  }
}