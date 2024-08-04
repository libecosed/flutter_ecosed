use flutter_rust_bridge::{frb, setup_default_user_utils};

#[frb(sync)]
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[frb(init)]
pub fn init_app() {
    setup_default_user_utils();
}
