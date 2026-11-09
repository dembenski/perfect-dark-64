#include "src/game/envfx_snow.h"

const GeoLayout pd64_falcon2_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_TRANSLATE_ROTATE_WITH_DL(LAYER_OPAQUE, 0, 5, -19, 90, 0, 0, pd64_falcon2_barrel_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, -3, 5, -6, pd64_falcon2_cell_left_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 3, 5, -6, pd64_falcon2_cell_right_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 0, 0, -2, pd64_falcon2_frame_lower_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 0, 10, -16, pd64_falcon2_front_sight_mesh_layer_1),
		GEO_TRANSLATE_ROTATE_WITH_DL(LAYER_OPAQUE, 0, -6, 9, 12, 0, 0, pd64_falcon2_grip_mesh_layer_1),
		GEO_TRANSLATE_ROTATE_WITH_DL(LAYER_OPAQUE, 0, -14, 10, 12, 0, 0, pd64_falcon2_grip_base_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 0, -2, -7, pd64_falcon2_guard_front_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 0, 8, 12, pd64_falcon2_hammer_mesh_layer_1),
		GEO_TRANSLATE_ROTATE_WITH_DL(LAYER_OPAQUE, 0, 5, -20, 90, 0, 0, pd64_falcon2_muzzle_ring_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 0, 10, 10, pd64_falcon2_rear_sight_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, -3, 5, 9, pd64_falcon2_serration_left_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 3, 5, 9, pd64_falcon2_serration_right_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 0, 5, -3, pd64_falcon2_slide_main_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 0, -1, -2, pd64_falcon2_trigger_mesh_layer_1),
		GEO_TRANSLATE_NODE_WITH_DL(LAYER_OPAQUE, 0, -4, -3, pd64_falcon2_trigger_guard_mesh_layer_1_with_revert),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
