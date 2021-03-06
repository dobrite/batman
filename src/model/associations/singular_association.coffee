#= require ./association

class Batman.SingularAssociation extends Batman.Association
  isSingular: true

  constructor: (@model, @label, options = {}) ->
    super
    @foreignKey = @options.foreignKey
    @primaryKey = @options.primaryKey

  provideDefaults: ->
    Batman.mixin super,
      name: Batman.helpers.camelize(@label)

  getAccessor: (association, model, label) ->
    # Check whether the relation has already been set on this model
    if recordInAttributes = association.getFromAttributes(this)
      return recordInAttributes

    # Make sure the related model has been loaded
    if association.getRelatedModel()
      proxy = @associationProxy(association)

      alreadyLoaded = Batman.Property.withoutTracking(-> proxy.get('loaded'))
      if !alreadyLoaded && association.options.autoload
        Batman.Property.withoutTracking(-> proxy.load())

    proxy

  setIndex: ->
    @index ||= new Batman.UniqueAssociationSetIndex(this, @[@indexRelatedModelOn])
