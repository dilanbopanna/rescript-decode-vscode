let getOptionString = (dict, key) => {
  dict->Js.Dict.get(key)->Belt.Option.flatMap(Js.Json.decodeString)
}

let getString = (dict, key, default) => {
  getOptionString(dict, key)->Belt.Option.getWithDefault(default)
}

let getIntFromString = (str, default) => {
  switch str->Belt.Int.fromString {
  | Some(int) => int
  | None => default
  }
}

let getIntFromJson = (json, default) => {
  switch json->Js.Json.classify {
  | JSONString(str) => getIntFromString(str, default)
  | JSONNumber(floatValue) => floatValue->Belt.Float.toInt
  | _ => default
  }
}

let getInt = (dict, key, default) => {
  switch Js.Dict.get(dict, key) {
  | Some(value) => getIntFromJson(value, default)
  | None => default
  }
}

let getFloatFromString = (str, default) => {
  switch str->Belt.Float.fromString {
  | Some(floatVal) => floatVal
  | None => default
  }
}

let getOptionFloatFromString = str => {
  str->Belt.Float.fromString
}

let getOptionFloatFromJson = json => {
  switch json->Js.Json.classify {
  | JSONString(str) => getOptionFloatFromString(str)
  | JSONNumber(floatValue) => Some(floatValue)
  | _ => None
  }
}

let getFloatFromJson = (json, default) => {
  switch json->Js.Json.classify {
  | JSONString(str) => getFloatFromString(str, default)
  | JSONNumber(floatValue) => floatValue
  | _ => default
  }
}

let getOptionFloat = (dict, key) => {
  switch Js.Dict.get(dict, key) {
  | Some(value) => getOptionFloatFromJson(value)
  | None => None
  }
}

let getFloat = (dict, key, default) => {
  dict
  ->Js.Dict.get(key)
  ->Belt.Option.map(json => getFloatFromJson(json, default))
  ->Belt.Option.getWithDefault(default)
}

let getOptionBool = (dict, key) => {
  dict->Js.Dict.get(key)->Belt.Option.flatMap(Js.Json.decodeBoolean)
}

let getBool = (dict, key, default) => {
  getOptionBool(dict, key)->Belt.Option.getWithDefault(default)
}

let getOptionIntFromString = str => {
  str->Belt.Int.fromString
}

let getOptionIntFromJson = json => {
  switch json->Js.Json.classify {
  | JSONString(str) => getOptionIntFromString(str)
  | JSONNumber(floatValue) => Some(floatValue->Belt.Float.toInt)
  | _ => None
  }
}

let getOptionInt = (dict, key) => {
  switch Js.Dict.get(dict, key) {
  | Some(value) => getOptionIntFromJson(value)
  | None => None
  }
}

let getOptionBool = (dict, key) => {
  dict->Js.Dict.get(key)->Belt.Option.flatMap(Js.Json.decodeBoolean)
}

let getOptionalJsonFromDict = (dict: Js.Dict.t<Js.Json.t>, key: Js.Dict.key) => {
  dict->Js.Dict.get(key)
}

let getJsonObjectFromDict = (dict, key) => {
  dict->Js.Dict.get(key)->Belt.Option.getWithDefault(Js.Json.object_(Js.Dict.empty()))
}

let getStrArrayFromJsonArray = jsonArr => {
  jsonArr->Belt.Array.keepMap(Js.Json.decodeString)
}

let getOptionStrArrayFromJson = json => {
  json->Js.Json.decodeArray->Belt.Option.map(getStrArrayFromJsonArray)
}

let getStrArrayFromDict = (dict, key, default) => {
  dict
  ->Js.Dict.get(key)
  ->Belt.Option.flatMap(getOptionStrArrayFromJson)
  ->Belt.Option.getWithDefault(default)
}

let getFloatArrayFromDict = (dict, key) => {
  dict
  ->Js.Dict.get(key)
  ->Belt.Option.flatMap(json =>
    json->Js.Json.decodeArray->Belt.Option.map(arr => arr->Belt.Array.keepMap(Js.Json.decodeNumber))
  )
  ->Belt.Option.getWithDefault([])
}

let getIntArrayFromJsonArray = jsonArr => {
  jsonArr->Belt.Array.keepMap(Js.Json.decodeNumber)->Js.Array2.map(Belt.Float.toInt)
}

let getOptionIntArrayFromJson = json => {
  json->Js.Json.decodeArray->Belt.Option.map(getIntArrayFromJsonArray)
}

let getIntArrayFromDict = (dict, key, default) => {
  dict
  ->Js.Dict.get(key)
  ->Belt.Option.flatMap(getOptionIntArrayFromJson)
  ->Belt.Option.getWithDefault(default)
}

let getOptionFloatArrayFromDict = (dict, key) => {
  dict
  ->Js.Dict.get(key)
  ->Belt.Option.flatMap(json =>
    json->Js.Json.decodeArray->Belt.Option.map(arr => arr->Belt.Array.keepMap(Js.Json.decodeNumber))
  )
}

let getOptionStrArrayFromDict = (dict, key) => {
  dict->Js.Dict.get(key)->Belt.Option.flatMap(getOptionStrArrayFromJson)
}

let getOptionIntArrayFromDict = (dict, key) => {
  dict->Js.Dict.get(key)->Belt.Option.flatMap(getOptionIntArrayFromJson)
}
