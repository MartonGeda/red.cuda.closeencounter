#pragma once

//includes system
#include <string>

// includes project
#include "red_type.h"

using namespace std;

namespace redutilcu
{
	namespace tools
	{
		bool is_number(const string& str);
		void trim_right(string& str);
		void trim_right(string& str, char c);
		void trim_left(string& str);
		void trim(string& str);
		string get_time_stamp();
		string convert_time_t(time_t t);

		//! Computes the total mass of the system
		var_t get_total_mass(int n, const sim_data_t *sim_data);
		//! Computes the total mass of the bodies with type in the system
		var_t get_total_mass(int n, body_type_t type, const sim_data_t *sim_data);
		void compute_bc(int n, bool verbose, const sim_data_t *sim_data, vec_t* R0, vec_t* V0);
		void transform_to_bc(int n, bool verbose, const sim_data_t *sim_data);
		void get_star_bc_phase(int n, bool verbose, const sim_data_t *sim_data, vec_t* R0, vec_t* V0);
		void transform_to_ac(int n, bool verbose, const sim_data_t *sim_data);

		var_t calculate_radius(var_t m, var_t density);
		var_t calculate_density(var_t m, var_t R);
		var_t caclulate_mass(var_t R, var_t density);

		void calc_position_after_collision(var_t m1, var_t m2, const vec_t* r1, const vec_t* r2, vec_t& r);
		void calc_velocity_after_collision(var_t m1, var_t m2, const vec_t* v1, const vec_t* v2, vec_t& v);
		void calc_physical_properties(const param_t &p1, const param_t &p2, param_t &p);

		int	kepler_equation_solver(var_t ecc, var_t mean, var_t eps, var_t* E);
		int calculate_phase(var_t mu, const orbelem_t* oe, vec_t* rVec, vec_t* vVec);
		int calculate_orbital_element(const var_t mu, orbelem_t* oe, const vec_t rVec, const vec_t vVec);

		void shift_into_range(const var_t lower, const var_t upper, var_t& value);
		var_t asinh(const var_t value);

		void print_vector(const vec_t *v);
	} /* tools */
} /* redutilcu_tools */
