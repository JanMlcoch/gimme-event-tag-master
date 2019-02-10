part of tag_master_model;

class QueryTags extends OverviewTags {
  @override
  QueryTags(OverviewTags overviewTags, List<Filter> filterList, {empty:false}) {
    if(!empty){
      Filters filters = new Filters(filterList);
      tags = filters.filtrate(overviewTags).tags;
    }
    else{
      tags = [];
    }
  }
}

class Filters {
  List<Filter> filters = [];

  Filters(List<Filter> inputFilters) {
    filters = inputFilters;
  }

  OverviewTags filtrate(OverviewTags overviewTags) {
    OverviewTags queryTags = model.overviewTags;
    for(Filter filter in filters){
      queryTags = filter.filtrate(queryTags);
    }
    return queryTags;
  }
}

class Filter {
  Filter() {
  }

  QueryTags filtrate(OverviewTags overviewTags) {
    QueryTags queryTags = new QueryTags(model.overviewTags,[],empty:true);
    for (SimpleTag tag in overviewTags.tags) {
      if (matches(tag)) {
        queryTags.tags.add(tag);
      }
    }
    return queryTags;
  }

  bool matches(SimpleTag tag) {
    return true;
  }
}

class SubstringFilter extends Filter {
  String substring;

  @override
  SubstringFilter(String incomingSubstring){
    substring = incomingSubstring;
  }

  @override
  bool matches(SimpleTag tag) {
    if (tag.name.contains(substring)) {
      return true;
    } else {
      return false;
    }
  }
}

class NotTypFilter extends Filter {
  int avoidedType;

  @override
  NotTypFilter(int type){
    avoidedType = type;
  }

  @override
  bool matches(SimpleTag tag) {
    if (tag.type==avoidedType) {
      return false;
    } else {
      return true;
    }
  }
}

class NotIdFilter extends Filter {
  int avoidedId;

  @override
  NotIdFilter(int id){
    avoidedId = id;
  }

  @override
  bool matches(SimpleTag tag) {
    if (tag.id==avoidedId) {
      return false;
    } else {
      return true;
    }
  }
}