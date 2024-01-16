local DefaultRails = {
	["RailL"] = {
		Offset = Vector3.new(-1.77,0,0),
		Size = Vector3.new(0.55,0.55,0.55),
		Color = "Rail",
		CanCollide = true, 
		Stripe = true,
		PGS = true,
		Material = true,
	},
	["RailR"] = {
		Offset = Vector3.new(1.77,0,0),
		Size = Vector3.new(0.55,0.55,0.55),
		Color = "Rail",
		CanCollide = true, 
		Stripe = true,
		PGS = true,
		Material = true,
	},
}

local Track = {
	Name = "Intamin LSM",
	Image = "rbxassetid://8699357675",
	LayoutOrder = 1,
	DevOnly = false,
	DefaultType = "Tri",
	Content = {
		["Modern [Pantheon]"] = {
			["LayoutOrder"] = 3,
			["Tri"] = {
				LayoutOrder = 1,
				
				Rails = {
					["RailL"] = DefaultRails.RailL,
					["RailR"] = DefaultRails.RailR,
					["Spine"] = {
						Offset = Vector3.new(0,-1.387,0),
						Size = Vector3.new(1.4,1.4,1.4),
						Color = "Spine",
						Material = true,
					}
						
				},
				Crosstie = {
					Color = "Crosstie",
					Material = true,
					
				}
			},
			["Flat"] = {
				LayoutOrder = 2,
				Rails = DefaultRails,
				Crosstie = {
					Color = "Crosstie",
					Material = true
				}
			},
			["Double"] = {
				LayoutOrder = 3,
				Rails = {
					
					["RailL"] = DefaultRails.RailL,
					["RailR"] = DefaultRails.RailR,
					["Spine1"] = {
						Offset = Vector3.new(0,-1.387,0),
						Size = Vector3.new(1.4,1.4,1.4),
						Color = "Spine",
						Material = true,
					},
					["Spine2"] = {
						Offset = Vector3.new(0,-1.387-2.5,0),
						Size = Vector3.new(1.4,1.4,1.4),
						Color = "Spine",
						Material = true,
					}
				},
				Crosstie = {
					Color = "Crosstie",
					Material = true
				}
			},
			["Flat [Crossbeam]"] = {
				LayoutOrder = 5,
				Rails = DefaultRails,
				Crossbeams = {
					["CrossbeamTop"] = {
						OffsetPrevious = Vector3.new(-1.77,0,-0.3),
						OffsetCurrent = Vector3.new(1.77,0,0.3),
						Size = Vector3.new(0.25,0.25,0.25),
						Color = "Rail",
						Material = true,
					}
				},
				Crosstie = {
					Color = "Crosstie",
					Material = true
				}
			},
			["Tri [Crossbeam]"] = {
				LayoutOrder = 4,

				Rails = {
					["RailL"] = DefaultRails.RailL,
					["RailR"] = DefaultRails.RailR,
					["Spine"] = {
						Offset = Vector3.new(0,-1.387,0),
						Size = Vector3.new(1.4,1.4,1.4),
						Color = "Spine",
						Material = true,
					}

				},
				Crossbeams = {
					["CrossbeamTop"] = {
						OffsetPrevious = Vector3.new(-1.77,0,-0.3),
						OffsetCurrent = Vector3.new(1.77,0,0.3),
						Size = Vector3.new(0.25,0.25,0.25),
						Color = "Rail",
						Material = true,
					}
				},
				Crosstie = {
					Color = "Crosstie",
					Material = true,

				}
			},
		},
		["Modern [Taron]"] = {
			["LayoutOrder"] = 2,
			["Tri"] = {
				LayoutOrder = 1,

				Rails = {
					["RailL"] = DefaultRails.RailL,
					["RailR"] = DefaultRails.RailR,
					["Spine"] = {
						Offset = Vector3.new(0,-3.069,0),
						Size = Vector3.new(0.55,0.55,0.55),
						Color = "Spine",
						Material = true,
					}

				},
				Crossbeams = {
					["CrossbeamTop"] = {
						OffsetPrevious = Vector3.new(-1.77,0,-0.3),
						OffsetCurrent = Vector3.new(1.77,0,0.3),
						Size = Vector3.new(0.25,0.25,0.25),
						Color = "Rail",
						Material = true,
						ConnectorMirror = true
	
					},
					
					["CrossbeamLeft"] = {
						OffsetPrevious = Vector3.new(-0.05,-3.15,0),
						OffsetCurrent = Vector3.new(-1.45,0,0),
						Size = Vector3.new(0.25,0.25,0.25),
						Color = "Rail",
						Material = true,
						SwapMirror = true,
						ConnectorMirror = true

					},
					["CrossbeamRight"] = {
						OffsetPrevious = Vector3.new(0.05,-3.15,0),
						OffsetCurrent = Vector3.new(1.45,0,0),
						Size = Vector3.new(0.25,0.25,0.25),
						Color = "Rail",
						Material = true,
						SwapMirror = true,
						ConnectorMirror = true
					},

				},
				ConnectorCrossbeams = {
					["CrossbeamTop1"] = {

						
						
						PreviousConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Rail",
							Material = true,
							OffsetPrevious = Vector3.new(-1.77,0,-0.3),
							OffsetCurrent = Vector3.new(-0.25,0,0.2),

						},
						CurrentConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Rail",
							Material = true,
							OffsetPrevious = Vector3.new(-0.25,0,-0.2),
							OffsetCurrent = Vector3.new(-1.77,0,0.3),
						}


					},
					["CrossbeamTop2"] = {

						

						PreviousConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Rail",
							Material = true,
							OffsetPrevious = Vector3.new(1.77,0,-0.3),
							OffsetCurrent = Vector3.new(0.25,0,0.2),

						},
						CurrentConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Rail",
							Material = true,
							OffsetPrevious = Vector3.new(0.25,0,-0.2),
							OffsetCurrent = Vector3.new(1.77,0,0.3),
						}


					},
					["CrossbeamLeft"] = {

						
						PreviousConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Rail",
							Material = true,

							OffsetPrevious = Vector3.new(-1.45,0,0),
							OffsetCurrent = Vector3.new(-0.02,-3.1,0),	

						},
						CurrentConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Rail",
							Material = true,

							OffsetPrevious = Vector3.new(-0.02,-3.1,0),
							OffsetCurrent = Vector3.new(-1.45,0,0),	

						},

						
					},
					["CrossbeamRight"] = {

						
						PreviousConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Rail",
							Material = true,

							OffsetPrevious = Vector3.new(1.45,0,0),
							OffsetCurrent = Vector3.new(0.02,-3.1,0),	

						},
						CurrentConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Rail",
							Material = true,

							OffsetPrevious = Vector3.new(0.02,-3.1,0),
							OffsetCurrent = Vector3.new(1.45,0,0),	
						},
					},

				},
				Crosstie = {
					Color = "Crosstie",
					Material = true,
					SwapMirror = true,
				}
			},
			["Flat"] = {
				LayoutOrder = 2,
				Rails = DefaultRails,
				Crosstie = {
					Color = "Crosstie",
					Material = true
				}
			},

		},
		["Classic"] = {
			["LayoutOrder"] = 1,
			["Tri"] = {
				LayoutOrder = 1,

				Rails = {
					["RailL"] = DefaultRails.RailL,
					["RailR"] = DefaultRails.RailR,
					["Spine"] = {
						Offset = Vector3.new(0,-3.54,0),
						Size = Vector3.new(0.55,0.55,0.55),
						Color = "Spine",
						Material = true,
					}

				},
				Crossbeams = {
					["CrossbeamTop"] = {
						OffsetPrevious = Vector3.new(-1.374,0,0),
						OffsetCurrent = Vector3.new(1.374,0,0),
						Size = Vector3.new(0.25,0.25,0.25),
						Color = "Crosstie",
						Material = true,
						ConnectorMirror = true

					},

					["CrossbeamLeft"] = {
						OffsetPrevious = Vector3.new(-1.3,-0.296,0),
						OffsetCurrent = Vector3.new(-0.05,-3.6,0),
						Size = Vector3.new(0.3,0.3,0.3),
						Color = "Crosstie",
						Material = true,
						SwapMirror = true,
						ConnectorMirror = true

					},
					["CrossbeamRight"] = {
						OffsetPrevious = Vector3.new(1.3,-0.296,0),
						OffsetCurrent = Vector3.new(0.05,-3.6,0),
						Size = Vector3.new(0.3,0.3,0.3),
						Color = "Crosstie",
						Material = true,
						SwapMirror = true,
						ConnectorMirror = true

					},

				},
				ConnectorCrossbeams = {
					["CrossbeamTop"] = {



						PreviousConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Crosstie",
							Material = true,
							OffsetPrevious = Vector3.new(-1.374,0,0),
							OffsetCurrent = Vector3.new(1.35,0,0.15),

						},
						CurrentConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Crosstie",
							Material = true,
							OffsetPrevious = Vector3.new(-1.374,0,-0.15),
							OffsetCurrent = Vector3.new(1.35,0,0),
						}


					},

					["CrossbeamLeft"] = {


						PreviousConnector = {
							Size = Vector3.new(0.3,0.3,0.3),
							Color = "Crosstie",
							Material = true,

							OffsetPrevious = Vector3.new(0.05,-3.615,0),
							OffsetCurrent =  Vector3.new(1.3,-0.296,0.25),	

						},
						CurrentConnector = {
							Size = Vector3.new(0.3,0.3,0.3),
							Color = "Crosstie",
							Material = true,

							OffsetPrevious = Vector3.new(1.3,-0.296,-0.25),
							OffsetCurrent = Vector3.new(0.05,-3.615,0),

						},


					},
					["CrossbeamRight"] = {


						PreviousConnector = {
							Size = Vector3.new(0.3,0.3,0.3),
							Color = "Crosstie",
							Material = true,

							OffsetPrevious = Vector3.new(-0.05,-3.615,0),
							OffsetCurrent = Vector3.new(-1.3,-0.296,0.25),

						},
						CurrentConnector = {
							Size = Vector3.new(0.3,0.3,0.3),
							Color = "Crosstie",
							Material = true,

							OffsetPrevious = Vector3.new(-1.3,-0.296,-0.25),
							OffsetCurrent = Vector3.new(-0.05,-3.615,0),

						},

					},

				},
				Crosstie = {
					Color = "Crosstie",
					Material = true,
					SwapMirror = true,
				}
			},
			["Box"] = {
				LayoutOrder = 1,

				Rails = {
					["RailL"] = DefaultRails.RailL,
					["RailR"] = DefaultRails.RailR,
					["SpineL"] = {
						Offset = Vector3.new(DefaultRails.RailL.Offset.X,-3.937,0),
						Size = Vector3.new(0.55,0.55,0.55),
						Color = "Spine",
						Material = true,
					},
					["SpineR"] = {
						Offset = Vector3.new(DefaultRails.RailR.Offset.X,-3.937,0),
						Size = Vector3.new(0.55,0.55,0.55),
						Color = "Spine",
						Material = true,
					}

				},
				Crossbeams = {
					["CrossbeamTop"] = {
						OffsetPrevious = Vector3.new(1.26,0,0),
						OffsetCurrent = Vector3.new(-1.26,0,0),
						Size = Vector3.new(0.25,0.25,0.25),
						Color = "Crosstie",
						Material = true,
						SwapMirror = true,
						ConnectorMirror = true

					},
					["CrossbeamBottom"] = {
						OffsetPrevious = Vector3.new(1.26,-3.937,0),
						OffsetCurrent = Vector3.new(-1.26,-3.937,0),
						Size = Vector3.new(0.25,0.25,0.25),
						Color = "Crosstie",
						Material = true,
						SwapMirror = true,
						ConnectorMirror = true

					},
				
					["CrossbeamLeft"] = {
						OffsetPrevious = Vector3.new(-1.15,-3.615,0),
						OffsetCurrent = Vector3.new(-1.15,-0.3,0),
						Size = Vector3.new(0.32,0.32,0.32),
						Color = "Crosstie",
						Mesh = script.SquareBeam,
						Material = true,
						SwapMirror = true,
						ConnectorMirror = true

					},
					["CrossbeamRight"] = {
						OffsetPrevious = Vector3.new(1.15,-3.615,0),
						OffsetCurrent = Vector3.new(1.15,-0.3,0),
						Size = Vector3.new(0.32,0.32,0.32),
						Color = "Crosstie",
						Mesh = script.SquareBeam,
						Material = true,
						SwapMirror = true,
						ConnectorMirror = true

					},

				},
				ConnectorCrossbeams = {
					["CrossbeamTop"] = {



						PreviousConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Crosstie",
							Material = true,
							OffsetPrevious = Vector3.new(-1.26,0,0),
							OffsetCurrent = Vector3.new(1.26,0,0.15),

						},
						CurrentConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Crosstie",
							Material = true,
							OffsetPrevious = Vector3.new(-1.26,0,-0.15),
							OffsetCurrent = Vector3.new(1.26,0,0),
							SwapMirror = true,
						}


					},
					["CrossbeamBottom"] = {



						PreviousConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Crosstie",
							Material = true,
							OffsetPrevious = Vector3.new(-1.26,-3.937,0),
							OffsetCurrent = Vector3.new(1.26,-3.937,0.15),

						},
						CurrentConnector = {
							Size = Vector3.new(0.25,0.25,0.25),
							Color = "Crosstie",
							Material = true,
							OffsetPrevious = Vector3.new(-1.26,-3.937,-0.15),
							OffsetCurrent = Vector3.new(1.26,-3.937,0),
							SwapMirror = true,
						}


					},

					["CrossbeamRight"] = {


						PreviousConnector = {
							Size = Vector3.new(0.32,0.32,0.32),
							Color = "Crosstie",
							Material = true,
							Mesh = script.SquareBeam,
							OffsetPrevious = Vector3.new(1.15,-0.4,0),
							OffsetCurrent = Vector3.new(1.15,-3.615,0.2),

						},
						CurrentConnector = {
							Size = Vector3.new(0.32,0.32,0.32),
							Color = "Crosstie",
							Material = true,
							Mesh = script.SquareBeam,
							OffsetPrevious = Vector3.new(1.15,-0.4,-0.2),
							OffsetCurrent = Vector3.new(1.15,-3.615,0),
						

						},

					},
					["CrossbeamLeft"] = {


						PreviousConnector = {
							Size = Vector3.new(0.32,0.32,0.32),
							Color = "Crosstie",
							Material = true,
							Mesh = script.SquareBeam,
							OffsetPrevious =Vector3.new(-1.15,-0.4,0),
							OffsetCurrent = Vector3.new(-1.15,-3.615,0.2),

						},
						CurrentConnector = {
							Size = Vector3.new(0.32,0.32,0.32),
							Color = "Crosstie",
							Material = true,
							Mesh = script.SquareBeam,
							OffsetPrevious = Vector3.new(-1.15,-0.4,-0.2),
							OffsetCurrent = Vector3.new(-1.15,-3.615,0),
						

						},

					},

				},
				Crosstie = {
					Color = "Crosstie",
					Material = true,
					SwapMirror = true,
				}
			},
			["Flat"] = {
				LayoutOrder = 2,
				Rails = DefaultRails,
				Crossbeams = {
					["CrossbeamTop"] = {
						OffsetPrevious = Vector3.new(-1.4,0,0),
						OffsetCurrent = Vector3.new(1.4,0,0),
						Size = Vector3.new(0.25,0.25,0.25),
						Color = "Crosstie",
						Mesh = script.SquareBeam,
						Material = true,
					}
				},

				Crosstie = {
					Color = "Crosstie",
					Material = true
				}
			},

		}
	},
	SpecialTypes = {
		["Normal"] = 1,
		["Connector"] = 2,


	}
}

return Track