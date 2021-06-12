class_name Tile

const build_able = [75, 76, 74, 77]

static func is_build_able(tile: int):
	return build_able.has(tile)
