SMODS.Atlas {
	key = "LynverseJokers",
	path = "LynverseJokers.png",
	px = 71,
	py = 95
}
SMODS.Atlas {
	key = "BeatBlockLyn",
	path = "BeatBlockLyn.png",
	px = 71,
	py = 95
}

SMODS.ObjectType({
	key = "lynverse_Lyns",
	default = "j_lynverse_future_lyn",
	cards = {
		j_lynverse_fire_lyn = true,
		j_lynverse_brick_lyn = true,
		j_lynverse_graffiti_lyn = true,
		j_lynverse_robo_lyn = true,
		j_lynverse_mermaid_lyn = true,
		j_lynverse_goblyn = true,
		j_lynverse_cat_lyn = true,
		j_lynverse_seal_lyn = true,
		j_lynverse_adventurer_lyn = true,
		j_lynverse_inklyn = true,
		j_lynverse_badgirl_lyn = true,
		j_lynverse_devil_lyn = true,
		j_lynverse_troll_lyn = true,
		j_lynverse_beatblock_lyn = true,
		j_lynverse_future_lyn = true,
		j_lynverse_merla = true,
		j_lynverse_wax_lyn = true,
		j_lynverse_scientist_lyn = true,
		j_lynverse_goth_lyn = true,
		j_lynverse_shark_lyn = true,
		j_lynverse_selensi_beach = true,
		j_lynverse_dj_lyn = true,
		j_lynverse_dream_lyn = true,
	},
})
SMODS.Attribute {
	key = 'Lyn'
}


SMODS.Sound({
	key = "dj_lyn_music",
	path = "dj_lyn_music.ogg",
	pitch = 0.70,
	select_music_track = function()
		return next(SMODS.find_card("j_lynverse_dj_lyn", false))
			and 200.1
	end,
})
SMODS.Sound({
	key = "dj_lyn_ability",
	path = "dj_lyn_ability.ogg",
})

SMODS.Joker {
	key = 'holly',
	discovered = false,
	loc_txt = {
		name = 'Holly Valentine',
		text = {
			"All played {C:hearts}#1#{} cards",
			"become {C:spades}#2#{} cards",
			"when scored, and this",
			"gets {C:mult}+#3#{} Mult each",
			"{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}"
		}
	},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { suit_from = 'Hearts', suit_to = 'Spades', bonus = 3, curr_mult = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.suit_from, card.ability.extra.suit_to, card.ability.extra.bonus, card.ability.extra.curr_mult } }
	end,
	rarity = 3,
	atlas = 'LynverseJokers',
	pos = { x = 0, y = 0 },
	cost = 7,
	calculate = function(self, card, context)
		if
			context.before and
			not context.blueprint
		then
			local hearts = {}
			for k, v in ipairs(context.scoring_hand) do
				if v:is_suit(card.ability.extra.suit_from) then 
					hearts[#hearts+1] = v
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						func = function()
							v:juice_up()
							v:change_suit(card.ability.extra.suit_to)
							return true;
						end
					})) 
				end
			end
			if #hearts > 0 then 
				card.ability.extra.curr_mult = card.ability.extra.curr_mult + (card.ability.extra.bonus * #hearts)
				return {
					message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.bonus * #hearts } },
				}
			end
			
		end
		if
			context.joker_main and
			card.ability.extra.curr_mult > 0
		then
			return {
				mult = card.ability.extra.curr_mult
			}
		end
	end
}

SMODS.Joker {
	key = 'faith',
	discovered = false,
	loc_txt = {
		name = 'Faith',
		text = {
			"Played face cards",
			"score {C:mult}+#1#{} Mult and lose",
			"{C:attention}1{} rank when scored",
		}
	},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 20 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	rarity = 3,
	atlas = 'LynverseJokers',
	pos = { x = 1, y = 0 },
	cost = 7,
	calculate = function(self, card, context)
		if
			context.individual and
			context.cardarea == G.play and
			context.other_card:is_face()
		then
			local other_card = context.other_card
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
					local suit_prefix = string.sub(other_card.base.suit, 1, 1)..'_'
					local rank_suffix = other_card.base.id == 2 and 14 or math.max(other_card.base.id-1, 2)
					if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
					elseif rank_suffix == 10 then rank_suffix = 'T'
					elseif rank_suffix == 11 then rank_suffix = 'J'
					elseif rank_suffix == 12 then rank_suffix = 'Q'
					elseif rank_suffix == 13 then rank_suffix = 'K'
					elseif rank_suffix == 14 then rank_suffix = 'A'
					end
					other_card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
					other_card:juice_up()
					play_sound('tarot1')
				return true end }))
			return {
				mult = card.ability.extra.mult,
				SMODS.calculate_effect({message = 'Downranked!', message_card = other_card}, card)
			}
		end
	end
}
SMODS.Joker {
	key = 'md-17801',
	discovered = false,
	loc_txt = {
		name = 'MD-17801',
		text = {
			"When another {C:attention}Joker{} or",
			"consumeable are sold,",
			"this gains {C:mult}+#1#{} or",
			"{C:mult}+#2#{} Mult, respectively",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult){}"
		}
	},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { bonus_jkr = 3, bonus_cnsm = 1, curr_mult = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus_jkr, card.ability.extra.bonus_cnsm, card.ability.extra.curr_mult } }
	end,
	rarity = 3,
	atlas = 'LynverseJokers',
	pos = { x = 2, y = 0 },
	cost = 6,
	calculate = function(self, card, context)
		if
			context.selling_card and
			not context.blueprint
		then
			if context.card.area == G.jokers then
				card.ability.extra.curr_mult = card.ability.extra.curr_mult + card.ability.extra.bonus_jkr
				if card.ability.extra.curr_mult >= 21 then
					check_for_unlock({ type = 'merla_MD_mult_reached' })
				end
				return {
					message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.bonus_jkr } },
					colour = G.C.MULT
				}
			elseif context.card.area == G.consumeables then
				card.ability.extra.curr_mult = card.ability.extra.curr_mult + card.ability.extra.bonus_cnsm
				if card.ability.extra.curr_mult >= 21 then
					check_for_unlock({ type = 'merla_MD_mult_reached' })
				end
				return {
					message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.bonus_cnsm } },
					colour = G.C.MULT
				}
			end
		end
		if
			context.joker_main
		then
			return {
				mult = card.ability.extra.curr_mult
			}
		end
	end
}

SMODS.Joker {
	key = 'fire_lyn',
	discovered = false,
	loc_txt = {
		name = 'Fire Lyn',
		text = {
			"At end of round",
			"{C:attention}destroy{} a random card",
			"held in hand, then",
			"this gains {X:mult,C:white} X#1# {} Mult",
			"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { bonus = 0.3, curr_xmult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus, card.ability.extra.curr_xmult } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 3, y = 0 },
	cost = 5,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult = card.ability.extra.curr_xmult,
			}
		end
		if
			context.end_of_round and
			context.game_over == false and
			context.cardarea == G.jokers and
			not context.blueprint
		then
			local wax_lyns = SMODS.find_card("j_lynverse_wax_lyn", false)
			print(#wax_lyns)
			if #wax_lyns > 0 then
				play_sound("whoosh1")
				for i = 1, #wax_lyns do
					wax_lyns[i]:juice_up(0.8, 0.8)
				end
				card.ability.extra.curr_xmult = card.ability.extra.curr_xmult + (card.ability.extra.bonus * #wax_lyns)
			else
				local card_to_destroy = {}
				card_to_destroy[#card_to_destroy+1] = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
				for i=#card_to_destroy, 1, -1 do
					local dest_card = card_to_destroy[i]
					if dest_card.ability.name == 'Glass Card' then 
						dest_card:shatter()
					else
						dest_card:start_dissolve(nil, i ~= #card_to_destroy)
					end
				end
				card.ability.extra.curr_xmult = card.ability.extra.curr_xmult + card.ability.extra.bonus
			end
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.curr_xmult}}
			}
		end
	end
}

SMODS.Joker {
	key = 'brick_lyn',
	discovered = false,
	loc_txt = {
		name = 'Brick Lyn',
		text = {
			"This gains {C:mult}+#1#{} Mult",
			"per {C:attention}Stone{} card scored",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { bonus = 2, curr_mult = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus, card.ability.extra.curr_mult } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 4, y = 0 },
	cost = 4,
	calculate = function(self, card, context)
		if
			context.individual and
			context.cardarea == G.play and
			context.other_card.ability.effect == 'Stone Card' and
			not context.blueprint
		then
			card.ability.extra.curr_mult = card.ability.extra.curr_mult + card.ability.extra.bonus
			return {
				message_card = card,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.bonus } },
				colour = G.C.MULT
			}
		end
		if
			context.joker_main and
			card.ability.extra.curr_mult > 0
		then
			return {
				mult = card.ability.extra.curr_mult
			}
		end
	end
}

SMODS.Joker {
	key = 'graffiti_lyn',
	discovered = false,
	loc_txt = {
		name = 'Graffiti Lyn',
		text = {
			"Lowers chip",
			"requirement by {C:attention}20%"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = {  } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 0, y = 1 },
	cost = 4,
	calculate = function(self, card, context)
		if
			context.first_hand_drawn and
			not (context.blueprint_card or card).getting_sliced
		then
			G.E_MANAGER:add_event(Event({func = function()
				G.E_MANAGER:add_event(Event({func = function()
					G.GAME.blind.chips = G.GAME.blind.chips * 0.8
					G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
					play_sound('timpani')
					delay(0.4)
					return true end }))
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '-20%'})
			return true end }))
		end
	end
}

SMODS.Joker {
	key = 'robo_lyn',
	discovered = false,
	loc_txt = {
		name = 'Robo-Lyn',
		text = {
			"This gains {X:mult,C:white} X#1# {} Mult when",
			"a {C:attention}Steel{} card is scored",
			"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult){}",
			"{C:red}Next two cards:",
			"{C:red}#3#",
			"{C:red}#4#",
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { bonus = 0.1, curr_xmult = 1, cardA = 'No cards!', cardB = '' } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus, card.ability.extra.curr_xmult, card.ability.extra.cardA, card.ability.extra.cardB } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 1, y = 1 },
	cost = 6,
	update = function(self, card, dt)
		if G.deck ~= nil then
			if G.deck.cards[#G.deck.cards] ~= nil then
				card.ability.extra.cardA = (G.deck.cards[#G.deck.cards].base.name or "error")
			else
				card.ability.extra.cardA = "None!"
			end
			if card.area == G.jokers then
				if G.deck.cards[#G.deck.cards-1] ~= nil then
					card.ability.extra.cardB = (G.deck.cards[#G.deck.cards-1].base.name or "error")
				else
					card.ability.extra.cardB = "None!"
				end
			else
				card.ability.extra.cardB = 'Buy to see more!'
			end
		else
			card.ability.extra.cardA = 'No cards!'
			card.ability.extra.cardB = ''
		end
	end,
	calculate = function(self, card, context)
		if
			context.individual and
			context.cardarea == G.play and
			context.other_card.ability.effect == 'Steel Card' and
			not context.blueprint
		then
			card.ability.extra.curr_xmult = card.ability.extra.curr_xmult + card.ability.extra.bonus
			return {
				message_card = card,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.curr_xmult } },
				colour = G.C.MULT
			}
		end
		if
			context.joker_main
		then
			return {
				xmult = card.ability.extra.curr_xmult
			}
		end
	end
}

SMODS.Joker {
	key = 'mermaid_lyn',
	discovered = false,
	loc_txt = {
		name = 'Mermaid Lyn',
		text = {
			"{C:mult}+#1#{} Mult for",
			"each remaining",
			"{C:attention}hand"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 9 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 2, y = 1 },
	cost = 6,
	calculate = function(self, card, context)
		if
			context.joker_main
		then
			return {
				mult = card.ability.extra.mult*(G.GAME.current_round.hands_left)
			}
		end
	end
}

SMODS.Joker {
	key = 'goblyn',
	discovered = false,
	loc_txt = {
		name = 'Goblyn',
		text = {
			"If played hand contains",
			"{C:attention}five{} cards ranked {C:attention}#1#{} or",
			"less, create the {C:planet}Planet{}",
			"card for played hand",
			"{C:inactive}(Must have room)"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { rank = 5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.rank } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 3, y = 1 },
	cost = 6,
	calculate = function(self, card, context)
		if
			context.joker_main and
			#context.full_hand == 5 and
			#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
		then
			local award_planet = true
			for k, v in ipairs(context.full_hand) do
				if v:get_id() > 5 and v:get_id() ~= 14 then
					award_planet = false
				end
			end
			if award_planet == true then
				check_for_unlock({ type = 'shark_lyn_goblyn_create_planet' })
				local card_type = 'Planet'
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
							local _planet = 0
							for k, v in pairs(G.P_CENTER_POOLS.Planet) do
								if v.config.hand_type == G.GAME.last_hand_played then
									_planet = v.key
								end
							end
							local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
							card:add_to_deck()
							G.consumeables:emplace(card)
							G.GAME.consumeable_buffer = 0
						return true
					end)}))
				return {
					message = localize('k_plus_planet')
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'cat_lyn',
	discovered = false,
	loc_txt = {
		name = 'Cat Lyn',
		text = {
			"{C:chips}+#1#{} Chips",
			"{C:green}#2# in #3#{} chance this",
			"card is destroyed",
			"at end of round",
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { chips = 150, num = 1, denom = 6 } },
	loc_vars = function(self, info_queue, card)
		local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'sleepchance')
		return { vars = { card.ability.extra.chips, new_numerator, new_denominator } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 4, y = 1 },
	cost = 5,
	calculate = function(self, card, context)
		if
			context.end_of_round and
			not context.individual and
			not context.repetition and
			not context.blueprint
		then
			if SMODS.pseudorandom_probability(card, 'cat_lyn', card.ability.extra.num, card.ability.extra.denom, 'sleepchance') then 
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end})) 
						return true
					end
				})) 
				return {
					message = 'Asleep!'
				}
			else
				return {
					message = 'Awake!'
				}
			end
		end
		if
			context.joker_main
		then
			return {
				chips = card.ability.extra.chips
			}
		end
	end
}

SMODS.Joker {
	key = 'seal_lyn',
	discovered = false,
	loc_txt = {
		name = 'Seal Lyn',
		text = {
			"{C:mult}+#1#{} Mult per card",
			"with a {C:attention}seal{} in",
			"your full deck",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { extra_per = 7, seal_count = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.extra_per, card.ability.extra.extra_per * (card.ability.extra.seal_count or 0) } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 0, y = 2 },
	cost = 6,
	update = function(self, card, dt)
		if G.playing_cards ~= nil then
			card.ability.extra.seal_count = 0
			for k, v in pairs(G.playing_cards) do
				if v.seal ~= nil then card.ability.extra.seal_count = card.ability.extra.seal_count + 1 end
			end
			if card.ability.extra.seal_count >= 5 then
				check_for_unlock({ type = 'wax_lyn_seal_lyn_mult_reached' })
			end
		end
	end,
	calculate = function(self, card, context)
		if
			context.joker_main and
			card.ability.extra.seal_count > 0
		then
			return {
				mult = card.ability.extra.seal_count * card.ability.extra.extra_per
			}
		end
	end
}

SMODS.Joker {
	key = 'adventurer_lyn',
	discovered = false,
	loc_txt = {
		name = 'Adventurer Lyn',
		text = {
			"{C:red}Rare {C:attention}Jokers{} each",
			"give {X:mult,C:white} X#1# {} Mult",
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { Xmult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 1, y = 2 },
	cost = 8,
	calculate = function(self, card, context)
		if
			context.other_joker and
			context.other_joker.config.center.rarity == 3 and
			card ~= context.other_joker
		then
			local other_joker = context.other_joker
			G.E_MANAGER:add_event(Event({
					func = function()
						other_joker:juice_up(0.5, 0.5)
						return true
					end
				})) 
			return {
				message_card = other_joker,
				Xmult = card.ability.extra.Xmult
			}
		end
	end
}

SMODS.Joker {
	key = 'inklyn',
	discovered = false,
	loc_txt = {
		name = 'Inklyn',
		text = {
			"Hand size can",
			"never go below {C:attention}#1#",
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { hand_size = 8, changes = 0, ready = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hand_size } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 2, y = 2 },
	cost = 4,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
			if G.hand.config.card_limit < card.ability.extra.hand_size and card.ability.extra.ready == 1 then
				card.ability.extra.ready = 0
				card.ability.extra.changes = card.ability.extra.changes + (G.hand.config.card_limit - card.ability.extra.hand_size)
				G.hand:change_size(card.ability.extra.hand_size - G.hand.config.card_limit)
			elseif
				G.hand.config.card_limit > card.ability.extra.hand_size and
				card.ability.extra.changes < 0 and
				card.ability.extra.ready == 1
			then
				card.ability.extra.ready = 0
				card.ability.extra.changes = card.ability.extra.changes + (G.hand.config.card_limit - card.ability.extra.hand_size)
				if card.ability.extra.changes <= 0 then
					G.hand:change_size(card.ability.extra.hand_size - G.hand.config.card_limit)
				else
					card.ability.extra.changes = 0
				end
			elseif G.hand.config.card_limit == card.ability.extra.hand_size or (G.hand.config.card_limit > card.ability.extra.hand_size and card.ability.extra.changes >= 0) then
				card.ability.extra.ready = 1
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if card.ability.extra.changes < 0 then
			G.hand:change_size(card.ability.extra.changes)
		end
		card.ability.extra.changes = 0
	end
}

SMODS.Joker {
	key = 'badgirl_lyn',
	discovered = false,
	loc_txt = {
		name = 'Bad Girl Lyn',
		text = {
			"{C:chips}+#1#{} Chips for each",
			"empty {C:attention}Joker{} slot",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { bonus = 100, curr_chips = 0, } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus, card.ability.extra.curr_chips } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 3, y = 2 },
	cost = 5,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN then
			card.ability.extra.curr_chips = (G.jokers.config.card_limit - #G.jokers.cards) * card.ability.extra.bonus
		else
			card.ability.extra.curr_chips = 0
		end
	end,
	calculate = function(self, card, context)
		if
			context.joker_main and
			(G.jokers.config.card_limit - #G.jokers.cards) > 0
		then
			return {
				chips = card.ability.extra.curr_chips,
			}
		end
	end
}

SMODS.Joker {
	key = 'winnie',
	discovered = false,
	loc_txt = {
		name = 'Winnie',
		text = {
			"Gains {X:mult,C:white} X#1# {} Mult when",
			"a {C:tarot}Wheel of Fortune{}",
			"is used",
			"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
		}
	},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { bonus = 1.0, curr_xmult = 1.0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus, card.ability.extra.curr_xmult } }
	end,
	rarity = 3,
	atlas = 'LynverseJokers',
	pos = { x = 4, y = 2},
	cost = 7,
	calculate = function(self, card, context)
		if
			context.using_consumeable
		then
			if
				context.consumeable.ability.name == 'The Wheel of Fortune'
			then
				card.ability.extra.curr_xmult = card.ability.extra.curr_xmult + card.ability.extra.bonus
				return {
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.curr_xmult } }
				}
			end
		end
		if
			context.joker_main
		then
			return {
				Xmult = card.ability.extra.curr_xmult
			}
		end
	end
}

SMODS.Joker {
	key = 'devil_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Devil Lyn',
		text = {
			"Retrigger",
			"{C:gold}Gold{} cards"
		},
		unlock = {
			"Play a",
			"{C:attention}Three of a Kind{}",
			"of {C:attention}6{}s"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { repetitions = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 0, y = 3},
	cost = 4,
	check_for_unlock = function(self, args)
		if args.type == 'hand' then
			if args.handname == 'Three of a Kind' then
				local sixes = 0
				for k, v in ipairs(args.scoring_hand) do
					if v:get_id() == 6 then
						sixes = sixes + 1
					end
				end
				if sixes == 3 then
					return true
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if
			context.repetition and (context.cardarea == G.hand or context.cardarea == G.play) and context.other_card.ability.name == 'Gold Card'
		then
			return {
				repetitions = card.ability.extra.repetitions
			}
		end
	end
}

SMODS.Joker {
	key = 'troll_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Troll Lyn',
		text = {
			"If scored hand contains",
			"{C:attention}equal{} number of {C:spades}Black",
			"and {C:hearts}Red{} cards,",
			"balance {C:chips}Chips{} and {C:mult}Mult"
		},
		unlock = {
			"Use {C:tarot}Justice{} {C:attention}#1#{} times",
			"{C:inactive}(#2#/#1#){}"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = {  } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		local current = 0
		if G.PROFILES and G.SETTINGS.profile then
			current = G.PROFILES[G.SETTINGS.profile].trollyn_justice_used or 0
		end
		return { vars = { 12, math.min(current, 12) } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 1, y = 3},
	cost = 7,
	check_for_unlock = function(self, args)
		if args.type == "trollyn_justice_used" and args.count >= 12 then
			return true
		end
	end,
	calculate = function(self, card, context)
		if
			context.joker_main and
			not context.blueprint
		then
			local blacks = 0
			local reds = 0
			for k, v in ipairs(context.scoring_hand) do
				if v:is_suit("Hearts") or v:is_suit("Diamonds") then 
					reds = reds + 1
				end
				if v:is_suit("Spades") or v:is_suit("Clubs") then
					blacks = blacks + 1
				end
			end
			if reds == blacks then 
				return {
					balance = true
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'beatblock_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Beat Lyn',
		text = {
			"{C:chips}When blue:",
			"{C:spades}Black{C:chips} cards give +#1# Chips",
			"{C:mult}When red:",
			"{C:hearts}Red{C:mult} cards give +#2# Mult",
			"{C:inactive}(Swaps when activated)"
		},
		unlock = {
			"Play a 5 card hand",
			"of alternating {C:spades}Black{}",
			"and {C:hearts}Red{} cards",
			"{C:red,E:2}No Wild Cards{}"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { chips = 20, mult = 3, bonus = 'Black' } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.bonus } }
	end,
	rarity = 1,
	atlas = 'BeatBlockLyn',
	pos = { x = 0, y = 0},
	cost = 4,
	set_sprites = function(self, card, front)
		if card.ability ~= nil then
			if card.ability.extra.bonus == 'Red' then
				card.children.center:set_sprite_pos({ x = 1, y = 0 })
			end
		end
	end,
	check_for_unlock = function(self, args)
		if args.type == 'hand' then
			if #args.scoring_hand == 5 then
				local prev_color = 0
				-- 1 is black, 2 is red, 0 is starter
				local alternating = true
				for k, v in ipairs(args.scoring_hand) do
					if v.ability.name == 'Wild Card' then
						alternating = false
					elseif v:is_suit("Hearts") or v:is_suit("Diamonds") then
						if prev_color == 0 or prev_color == 1 then
							prev_color = 2
						else
							alternating = false
						end
					elseif v:is_suit("Spades") or v:is_suit("Clubs") then
						if prev_color == 0 or prev_color == 2 then
							prev_color = 1
						else
							alternating = false
						end
					else
						alternating = false
					end
				end
				if alternating == true then
					return true
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if
			context.individual and
			context.cardarea == G.play
		then
			if card.ability.extra.bonus == 'Red' then
				if context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds") then
					G.E_MANAGER:add_event(Event({
						trigger = "after", 
						delay = 0.1, 
						func = function()
							card:juice_up(0.3, 0.4)
							play_sound('generic1')
							card.children.center:set_sprite_pos({ x = 0, y = 0 })
							
							return true
						end
					}))
					card.ability.extra.bonus = 'Black'
					return {
						mult = card.ability.extra.mult
					}
				end
			else
				if context.other_card:is_suit("Spades") or context.other_card:is_suit("Clubs") then
					G.E_MANAGER:add_event(Event({
						trigger = "after", 
						delay = 0.1, 
						func = function()
							card:juice_up(0.3, 0.4)
							play_sound('generic1')
							card.children.center:set_sprite_pos({ x = 1, y = 0 })
							
							return true
						end
					}))
					card.ability.extra.bonus = 'Red'
					return {
						chips = card.ability.extra.chips
					}
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'future_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Future Lyn',
		text = {
			"Retrigger all cards in {C:attention}poker",
			"{C:attention}hands{} that have already",
			"been played this round"
		},
		unlock = {
			"Redeem",
			"Petroglyph"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { repetitions = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 3, y = 3},
	cost = 5,
	check_for_unlock = function(self, args)
		if args.type == "future_lyn_petroglyph_redeemed" then
			return true
		end
	end,
	calculate = function(self, card, context)
		if
			context.repetition and
			context.cardarea == G.play and 
			G.GAME.hands[context.scoring_name] and
			G.GAME.hands[context.scoring_name].played_this_round > 1
		then
			return {
				repetitions = card.ability.extra.repetitions
			}
		end
	end,
}

SMODS.Joker {
	key = 'cloud_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Cloud Lyn',
		text = {
			"Earn {C:money}$#1#{} per empty {C:attention}Joker",
			"slot at end of round"
		},
		unlock = {
			"Reach Ante level {C:attention}2{}",
			"with no {C:attention}Jokers{}"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { money = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 4, y = 3},
	cost = 4,
	check_for_unlock = function(self, args)
		if args.type == "ante_up" then
			if args.ante >= 2 and #G.jokers.cards == 0 then
				return true
			end
		end
	end,
	calc_dollar_bonus = function(self, card)
		local empty = (G.jokers.config.card_limit - #G.jokers.cards)
		if empty > 0 then
			return (card.ability.extra.money * empty)
		end
	end
}

SMODS.Joker {
	key = 'merla',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Knight Lyn',
		text = {
			"{C:mult}+#1#{} Mult for each level",
			"of played hand {C:attention}above #2#"
		},
		unlock = {
			"Reach {C:mult}+21{} Mult",
			"with {C:attention}MD-17801{}"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 4, level = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.level } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 0, y = 4},
	cost = 5,
	check_for_unlock = function(self, args)
		if args.type == "merla_MD_mult_reached" then
			return true
		end
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
		then
			if G.GAME.hands[context.scoring_name].level > 1 then
				return {
					mult = (G.GAME.hands[context.scoring_name].level - card.ability.extra.level) * card.ability.extra.mult
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'wax_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Wax Lyn',
		text = {
			"All played {C:attention}face{} cards",
			"become {C:attention}Wild{} cards",
			"and gain a random",
			"{C:attention}seal{} when scored"
		},
		unlock = {
			"Reach {C:mult}+35{} Mult",
			"with {C:attention}Seal Lyn{}"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = {  } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 1, y = 4},
	cost = 7,
	check_for_unlock = function(self, args)
		if args.type == "wax_lyn_seal_lyn_mult_reached" then
			return true
		end
	end,
	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then
			local faces = 0
			for k, v in ipairs(context.scoring_hand) do
				if v:is_face() then
					faces = faces + 1
					v:set_ability('m_wild', nil, true)
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end
					}))
					if v.seal == nil then
						local random_seal = SMODS.poll_seal {key = "lynverse", guaranteed = true}
						v:set_seal(random_seal)
					end
				end
			end
			if faces > 0 then
				return {
					message = "Wild",
					colour = G.C.FILTER
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'scientist_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Scientist Lyn',
		text = {
			"When {C:attention}Blind{} is selected,",
			"create a random {C:attention}Lyn",
			"{C:inactive}(Must have room)"
		},
		unlock = {
			"Have at least",
			"{C:attention}3 Lyn Jokers{} at",
			"the same time"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = {  } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 2, y = 4},
	cost = 5,
	check_for_unlock = function(self, args)
		if args.type == 'modify_jokers' then
			local count = 0
			for k, v in pairs(G.jokers.cards) do
				if v:has_attribute('Lyn') then
					count = count + 1
				end
			end
			if count >= 3 then
				return true
			end
		end
	end,
	calculate = function(self, card, context)
		if context.setting_blind and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
			G.GAME.joker_buffer = G.GAME.joker_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					SMODS.add_card {
						set = 'lynverse_Lyns',
						key_append = 'scientist'
					}
					G.GAME.joker_buffer = 0
					return true
				end
			}))
			return {
				message = "Zap!"
			}
		end
	end
}

SMODS.Joker {
	key = 'goth_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Goth Lyn',
		text = {
			"Create a {C:spectral}Spectral{} card",
			"every {C:attention}#1# {C:tarot}Tarot{} cards played",
			"{C:inactive}(Must have room)",
			"{C:attention}#2# {C:inactive}remaining"
		},
		unlock = {
			"Open {C:attention}3{} {C:spectral}Spectral{}",
			"packs in one run"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { amount = 3, remaining = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.amount, card.ability.extra.remaining } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 3, y = 4},
	cost = 6,
	check_for_unlock = function(self, args)
		if args.type == 'goth_lyn_spectral_packs_opened' and args.count >= 3 then
			return true
		end
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == "Tarot" then 
			if not context.blueprint then
				card.ability.extra.remaining = card.ability.extra.remaining - 1
			end
			if card.ability.extra.remaining <= 0 then
				card.ability.extra.remaining = card.ability.extra.amount
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						func = (function()
							SMODS.add_card {
								set = 'Spectral',
								key_append = 'goth'
							}
							G.GAME.consumeable_buffer = 0
							return true
						end)
					}))
					return {
						message = localize('k_plus_spectral'),
						colour = G.C.SECONDARY_SET.Spectral
					}
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'shark_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Shark Lyn',
		text = {
			"Gains {C:chips}Chips{} equal to rank",
			"of any discarded card",
			"ranked {C:attention}2{}, {C:attention}3{}, {C:attention}4{}, or {C:attention}5",
			"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
		},
		unlock = {
			"Create a {C:planet}Planet{}",
			"card via {C:attention}Goblyn{}"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { chips = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 4, y = 4},
	cost = 6,
	check_for_unlock = function(self, args)
		if args.type == 'shark_lyn_goblyn_create_planet' then
			return true
		end
	end,
	calculate = function(self, card, context)
		if
			context.discard and
			context.other_card:get_id() <= 5 and
			context.other_card:get_id() >= 2 and
			not context.blueprint
		then
			card.ability.extra.chips = card.ability.extra.chips + context.other_card:get_id()
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
			}
		end
		if
			context.joker_main
		then
			return {
				chips = card.ability.extra.chips
			}
		end
	end
}
--[[
SMODS.Joker {
	key = 'dryad_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Dryad Lyn',
		text = {
			"When {C:attention}Blind{} is selected",
			"this gains {C:mult}Mult{} equal",
			"to {C:red}#2#X {C:attention}Ante{} value",
			"{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult)"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { mult = 0, multiplier = 1.25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.multiplier } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 0, y = 5},
	cost = 6,
	calculate = function(self, card, context)
		if
			context.setting_blind and
			not context.blueprint
		then
			card.ability.extra.mult = card.ability.extra.mult + (G.GAME.round_resets.ante * card.ability.extra.multiplier)
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
			}
		end
		if
			context.joker_main
		then
			return {
				mult = card.ability.extra.mult
			}
		end
	end
}
--]]

SMODS.Joker {
	key = 'dream_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Dream Lyn',
		text = {
			"{X:mult,C:white} X#1# {} Mult for every",
			"{C:tarot}Tarot{} card held",
			"{C:attention}+#2#{} consumable slots",
		},
		unlock = {
			"Use {C:tarot}The Fool{}",
			"{C:attention}3{} times",
			"in one run"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { xmult_per = 0.65, slots = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_per, card.ability.extra.slots } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 0, y = 5},
	cost = 6,
	check_for_unlock = function(self, args)
		if args.type == 'dream_lyn_fools_used' and args.count >= 3 then
			return true
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if G.consumeables.config.card_count > 0 then
				local tarots = 0
				for k, v in ipairs(G.consumeables.cards) do
					if v.ability.set == 'Tarot' then
						tarots = tarots + 1
					end
				end
				if tarots > 0 then
					return {
						xmult = 1 + (card.ability.extra.xmult_per * tarots)
					}
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'selensi_beach',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Selensi Beach',
		text = {
			"Booster Packs",
			"gain {C:attention}+#1#{} choice",
			"and {C:attention}+#2#{} size",
		},
		unlock = {
			"Open {C:attention}20{}",
			"booster packs",
			"in one run"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { bonus_choice = 1, bonus_size = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus_choice, card.ability.extra.bonus_size } }
	end,
	rarity = 1,
	atlas = 'LynverseJokers',
	pos = { x = 1, y = 5},
	cost = 4,
	check_for_unlock = function(self, args)
		if args.type == 'selensi_beach_packs_opened' and args.count >= 20 then
			return true
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_choice_mod =  (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra.bonus_choice
		G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) + card.ability.extra.bonus_size
	end,
	remove_from_deck = function(self, card, from_debuff)
		if G.GAME.modifiers.booster_choice_mod ~= nil then
			G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod - card.ability.extra.bonus_choice
		end
		if G.GAME.modifiers.booster_size_mod ~= nil then
			G.GAME.modifiers.booster_size_mod = G.GAME.modifiers.booster_size_mod - card.ability.extra.bonus_size
		end
	end
}

SMODS.Joker {
	key = 'dj_lyn',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'DJ Lyn',
		text = {
			"All {C:attention}Jokers{} give",
			"{X:mult,C:white} X#1# {} Mult",
			"{C:inactive}(Changes the music)"
		},
		unlock = {
			"Have {C:attention}Beat Lyn",
			"and {C:attention}Future Lyn",
			"at the same time"
		}
	},
	attributes = {'Lyn'},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { xmult = 1.2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	rarity = 2,
	atlas = 'LynverseJokers',
	pos = { x = 2, y = 5},
	cost = 6,
	check_for_unlock = function(self, args)
		if args.type == 'modify_jokers' then
			local future_lyns = SMODS.find_card("j_lynverse_future_lyn", true)
			local beatblock_lyns = SMODS.find_card("j_lynverse_beatblock_lyn", true)
			if #future_lyns > 0 and #beatblock_lyns > 0 then
				return true
			end
		end
	end,
	calculate = function(self, card, context)
		if context.other_joker then
			
			local other_joker = context.other_joker
			G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("lynverse_dj_lyn_ability", math.random()*0.2 + 0.9, 1.0)
						other_joker:juice_up(0.5, 0.5)
						return true
					end
				})) 
			return {
				--sound = "lynverse_dj_lyn_ability",
				message_card = other_joker,
				Xmult = card.ability.extra.xmult,
			}
		end
	end
}

SMODS.Joker {
	key = 'finley',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Finley',
		text = {
			"Gains {C:chips}+#2#{} Chips per",
			"{C:hearts}Hearts{} card played or",
			"{C:spades}Spades{} card discarded",
			"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
		},
		unlock = {
			"Have {C:attention}Wax Lyn",
			"and {C:attention}Fire Lyn",
			"at the same time"
		}
	},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { chips = 20, add = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.add } }
	end,
	rarity = 3,
	atlas = 'LynverseJokers',
	pos = { x = 3, y = 5},
	cost = 6,
	check_for_unlock = function(self, args)
		if args.type == 'modify_jokers' then
			local wax_lyns = SMODS.find_card("j_lynverse_wax_lyn", true)
			local fire_lyns = SMODS.find_card("j_lynverse_fire_lyn", true)
			if #wax_lyns > 0 and #fire_lyns > 0 then
				return true
			end
		end
	end,
	calculate = function(self, card, context)
		if
			context.discard and
			context.other_card:is_suit("Spades") and
			not context.blueprint
		then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.add
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
			}
		end
		if
			context.individual and
			context.cardarea == G.play and
			context.other_card:is_suit("Hearts") and
			not context.blueprint
		then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.add
			return {
				message = localize('k_upgrade_ex'),
				message_card = card,
				colour = G.C.CHIPS,
			}
		end
		if
			context.joker_main
		then
			return {
				chips = card.ability.extra.chips
			}
		end
	end
}

SMODS.Joker {
	key = 'neotiyeth',
	discovered = false,
	unlocked = false,
	loc_txt = {
		name = 'Neotiyeth',
		text = {
			"+{X:mult,C:white} X#1# {} Mult per {C:attention}Queen",
			"played this hand, and",
			"{C:attention}Queens{} are {C:attention}revived{}",
			"when destroyed",
		},
		unlock = {
			"{C:red}Destroy{} a",
			"{C:attention}Queen of Hearts"
		}
	},
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { xmult_per = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_per } }
	end,
	rarity = 3,
	atlas = 'LynverseJokers',
	pos = { x = 4, y = 5},
	cost = 7,
	check_for_unlock = function(self, args)
		if args.type == 'neotiyeth_card_destroyed' then
			if args.destroyed_card:get_id() == 12 and args.destroyed_card:is_suit('Hearts') then
				return true
			end
		end
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards and not context.blueprint then
			local queens = 0
			for k, v in ipairs(context.removed) do
				if v:get_id() == 12 then
					queens = queens + 1
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local copy_card = copy_card(v, nil, nil, G.playing_card)
					copy_card:add_to_deck()
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, copy_card)
					G.hand:emplace(copy_card)
					copy_card.states.visible = nil

					G.E_MANAGER:add_event(Event({
						func = function()
							copy_card:start_materialize()
							return true
						end
					}))
				end
			end
			if queens > 0 then
				return {
					message = "Revived!",
					colour = G.C.CHIPS,
					func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								SMODS.calculate_context({ playing_card_added = true, cards = { copy_card } })
								return true
							end
						}))
					end
				}
			end
		end
		if
			context.joker_main
		then
			local queens = 0
			for k, v in ipairs(context.full_hand) do
				if v:get_id() == 12 then
					queens = queens + card.ability.extra.xmult_per
				end
			end
			if queens > 0 then
				return {
					Xmult = queens + 1
				}
			end
		end
	end
}