type scenatio = {
  //Exact name of the file in Scenes/Maps e.g.: "Scrap"
  map: string;
  rounds: {
    message: string,
    // Only one of enemy_distribution/enemy_count/enemies may be used per round
    // Specify number of enemies per element
    enemy_distribution: {
      fire: number;
      water: number;
      air: number;
      earth: number;
    };
    // Specify total number of enemies
    enemy_count: 4;
    // Specify each enemy in order
    enemies: ("fire" | "water" | "air" | "earth")[];
    round_time: number;
    spawn_time: number;
    initial_spawn_time: number;
    // When true, upon loosing the same round will just restart to try again
    retry: boolean;
  }[];
};
