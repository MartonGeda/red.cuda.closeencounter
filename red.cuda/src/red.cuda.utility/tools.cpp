// includes system
#include <cctype>
#include <cmath>
#include <ctime>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>

// includes project
#include "tools.h"
#include "red_macro.h"

using namespace std;

namespace redutilcu
{
namespace tools
{
bool is_number(const string& str)
{
   for (size_t i = 0; i < str.length(); i++)
   {
	   if (std::isdigit(str[i]) || str[i] == 'e' || str[i] == 'E' || str[i] == '.' || str[i] == '-' || str[i] == '+')
	   {
           continue;
	   }
	   else
	   {
		   return false;
	   }
   }
   return true;
}

/// Removes all trailing white-space characters from the current std::string object.
void trim_right(string& str)
{
	// trim trailing spaces
	size_t endpos = str.find_last_not_of(" \t");
	if (string::npos != endpos )
	{
		str = str.substr(0, endpos + 1);
	}
}

/// Removes all trailing characters after the first c character
void trim_right(string& str, char c)
{
	// trim trailing spaces
	size_t endpos = str.find(c);
	if (string::npos != endpos )
	{
		str = str.substr(0, endpos);
	}
}

/// Removes all leading white-space characters from the current std::string object.
void trim_left(string& str)
{
	// trim leading spaces
	size_t startpos = str.find_first_not_of(" \t");
	if (string::npos != startpos )
	{
		str = str.substr( startpos );
	}
}

/// Removes all leading and trailing white-space characters from the current std::string object.
void trim(string& str)
{
	trim_right(str);
	trim_left(str);
}

string get_time_stamp()
{
	static char time_stamp[20];

	time_t now = time(NULL);
	strftime(time_stamp, 20, "%Y-%m-%d %H:%M:%S", localtime(&now));

	return string(time_stamp);
}

string convert_time_t(time_t t)
{
	ostringstream convert;	// stream used for the conversion
	convert << t;			// insert the textual representation of 't' in the characters in the stream
	return convert.str();
}

var_t get_total_mass(int n, body_type_t type, const sim_data_t *sim_data)
{
	var_t total_mass = 0.0;

	param_t* p = sim_data->h_p;
	for (int j = n - 1; j >= 0; j--)
	{
		if (sim_data->h_body_md[j].body_type == type)
		{
			total_mass += p[j].mass;
		}
	}

	return total_mass;
}

var_t get_total_mass(int n, const sim_data_t *sim_data)
{
	var_t total_mass = 0.0;

	param_t* p = sim_data->h_p;
	for (int j = n - 1; j >= 0; j--)
	{
		total_mass += p[j].mass;
	}

	return total_mass;
}

void compute_bc(int n, bool verbose, const sim_data_t *sim_data, vec_t* R0, vec_t* V0)
{
	const param_t* p = sim_data->h_p;
	const vec_t* r = sim_data->h_y[0];
	const vec_t* v = sim_data->h_y[1];

	for (int j = n - 1; j >= 0; j-- )
	{
		var_t m = p[j].mass;
		R0->x += m * r[j].x;
		R0->y += m * r[j].y;
		R0->z += m * r[j].z;

		V0->x += m * v[j].x;
		V0->y += m * v[j].y;
		V0->z += m * v[j].z;
	}
	var_t M0 = get_total_mass(n, sim_data);

	R0->x /= M0;	R0->y /= M0;	R0->z /= M0;
	V0->x /= M0;	V0->y /= M0;	V0->z /= M0;

	if (verbose)
	{
		cout << "Position and velocity of the barycenter:" << endl;
		cout << "R0: ";		print_vector(R0);
		cout << "V0: ";		print_vector(V0);
	}
}

void transform_to_bc(int n, bool verbose, const sim_data_t *sim_data)
{
	if (verbose)
	{
		cout << "Transforming to barycentric system ... ";
	}

	// Position and velocity of the system's barycenter
	vec_t R0 = {0.0, 0.0, 0.0, 0.0};
	vec_t V0 = {0.0, 0.0, 0.0, 0.0};

	compute_bc(n, verbose, sim_data, &R0, &V0);

	vec_t* r = sim_data->h_y[0];
	vec_t* v = sim_data->h_y[1];
	// Transform the bodies coordinates and velocities
	for (int j = n - 1; j >= 0; j-- )
	{
		r[j].x -= R0.x;		r[j].y -= R0.y;		r[j].z -= R0.z;
		v[j].x -= V0.x;		v[j].y -= V0.y;		v[j].z -= V0.z;
	}

	if (verbose)
	{
		cout << "done" << endl;
	}
}

void get_star_bc_phase(int n, bool verbose, const sim_data_t *sim_data, vec_t* R0, vec_t* V0)
{
	const vec_t* r = sim_data->h_y[0];
	const vec_t* v = sim_data->h_y[1];
	bool isstar = false;

	for (int j = 0; j < n; j++ )
	{
		if (BODY_TYPE_STAR == sim_data->h_body_md->body_type)
		{
			R0->x = r[j].x;		R0->y = r[j].y;		R0->z = r[j].z;
			V0->x = v[j].x;		V0->y = v[j].y;		V0->z = v[j].z;
			isstar = true;
			break;
		}
	}
	if (!isstar)
	{
		throw string("No star is included!");
	}

	if (verbose)
	{
		cout << "Position and velocity of star:" << endl;
		cout << "R0: ";		print_vector(R0);
		cout << "V0: ";		print_vector(V0);
	}
}

void transform_to_ac(int n, bool verbose, const sim_data_t *sim_data)
{
	if (verbose)
	{
		cout << "Transforming to astrocentric system ... ";
	}

	// Position and velocity of the system's astrocenter
	vec_t R0 = {0.0, 0.0, 0.0, 0.0};
	vec_t V0 = {0.0, 0.0, 0.0, 0.0};

	get_star_bc_phase(n, verbose, sim_data, &R0, &V0);

	vec_t* r = sim_data->h_y[0];
	vec_t* v = sim_data->h_y[1];
	// Transform the bodies coordinates and velocities

	for (int j = n - 1; j >= 0; j-- )
	{
		r[j].x -= R0.x;		r[j].y -= R0.y;		r[j].z -= R0.z;
		v[j].x -= V0.x;		v[j].y -= V0.y;		v[j].z -= V0.z;
	}

	if (verbose)
	{
		cout << "done" << endl;
	}
}

var_t calculate_radius(var_t m, var_t density)
{
	static var_t four_pi_over_three = 4.1887902047863909846168578443727;

	return pow(1.0/four_pi_over_three * m/density, 1.0/3.0);
}

var_t calculate_density(var_t m, var_t R)
{
	static var_t four_pi_over_three = 4.1887902047863909846168578443727;

	if (R == 0.0)
	{
		return 0.0;
	}
	return m / (four_pi_over_three * CUBE(R));
}

var_t caclulate_mass(var_t R, var_t density)
{
	static var_t four_pi_over_three = 4.1887902047863909846168578443727;

	return four_pi_over_three * CUBE(R) * density;
}

void calc_position_after_collision(var_t m1, var_t m2, const vec_t* r1, const vec_t* r2, vec_t& r)
{
	const var_t M = m1 + m2;

	r.x = (m1 * r1->x + m2 * r2->x) / M;
	r.y = (m1 * r1->y + m2 * r2->y) / M;
	r.z = (m1 * r1->z + m2 * r2->z) / M;
}

void calc_velocity_after_collision(var_t m1, var_t m2, const vec_t* v1, const vec_t* v2, vec_t& v)
{
	const var_t M = m1 + m2;

	v.x = (m1 * v1->x + m2 * v2->x) / M;
	v.y = (m1 * v1->y + m2 * v2->y) / M;
	v.z = (m1 * v1->z + m2 * v2->z) / M;
}

void calc_physical_properties(const param_t &p1, const param_t &p2, param_t &p)
{
	// Calculate V = V1 + V2
	var_t volume = 4.188790204786391 * (CUBE(p1.radius) + CUBE(p2.radius));

	p.mass	  = p1.mass + p2.mass;
	p.density = p.mass / volume;
	p.radius  = calculate_radius(p.mass, p.density);
	p.cd      = p1.cd;
}

int	kepler_equation_solver(var_t ecc, var_t mean, var_t eps, var_t* E)
{
	if (ecc == 0.0 || mean == 0.0 || mean == PI)
	{
        *E = mean;
		return 0;
    }
    *E = mean + ecc * (sin(mean)) / (1.0 - sin(mean + ecc) + sin(mean));
    var_t E1 = 0.0;
    var_t error;
    int_t step = 0;
    do
	{
        E1 = *E - (*E - ecc * sin(*E) - mean) / (1.0 - ecc * cos(*E));
        error = fabs(E1 - *E);
        *E = E1;
    } while (error > eps && step++ <= 15);
	if (step > 15 )
	{
		return 1;
	}

	return 0;
}

int calculate_phase(var_t mu, const orbelem_t* oe, vec_t* rVec, vec_t* vVec)
{
    var_t ecc = oe->ecc;
	var_t E = 0.0;
	if (kepler_equation_solver(ecc, oe->mean, 1.0e-14, &E) == 1)
	{
		return 1;
	}
    var_t v = 2.0 * atan(sqrt((1.0 + ecc) / (1.0 - ecc)) * tan(E / 2.0));

    var_t p = oe->sma * (1.0 - SQR(ecc));
    var_t r = p / (1.0 + ecc * cos(v));
    var_t kszi = r * cos(v);
    var_t eta = r * sin(v);
    var_t vKszi = -sqrt(mu / p) * sin(v);
    var_t vEta = sqrt(mu / p) * (ecc + cos(v));

    var_t cw = cos(oe->peri);
    var_t sw = sin(oe->peri);
    var_t cO = cos(oe->node);
    var_t sO = sin(oe->node);
    var_t ci = cos(oe->inc);
    var_t si = sin(oe->inc);

    vec_t P;
	P.x = cw * cO - sw * sO * ci;
	P.y = cw * sO + sw * cO * ci;
	P.z = sw * si;
    vec_t Q;
	Q.x = -sw * cO - cw * sO * ci;
	Q.y = -sw * sO + cw * cO * ci;
	Q.z = cw * si;

	rVec->x = kszi * P.x + eta * Q.x;
	rVec->y = kszi * P.y + eta * Q.y;
	rVec->z = kszi * P.z + eta * Q.z;

	vVec->x = vKszi * P.x + vEta * Q.x;
	vVec->y = vKszi * P.y + vEta * Q.y;
	vVec->z = vKszi * P.z + vEta * Q.z;

	return 0;
}

int calculate_orbital_element(const var_t mu, orbelem_t* oe, const vec_t rVec, const vec_t vVec)
{
    const var_t sq2 = 1.0e-14;
    const var_t sq3 = 1.0e-14;

	// Calculate energy, h
	var_t v2 = SQR(vVec.x) + SQR(vVec.y) + SQR(vVec.z);
	var_t r2 = SQR(rVec.x) + SQR(rVec.y) + SQR(rVec.z);
	var_t r = sqrt(r2);

	var_t h = v2 / 2.0 - (mu / sqrt(r2));

    vec_t cVec = {rVec.y*vVec.z - rVec.z*vVec.y, rVec.z*vVec.x - rVec.x*vVec.z, rVec.x*vVec.y - rVec.y*vVec.x, 0.0};
	vec_t lVec = {(-mu / r) * rVec.x + vVec.y*cVec.z - vVec.z*cVec.y, (-mu / r) * rVec.y + vVec.z*cVec.x - vVec.x*cVec.z, (-mu / r) * rVec.z + vVec.x*cVec.y - vVec.y*cVec.x , 0.0};

	var_t rv = rVec.x*vVec.x + rVec.y*vVec.y + rVec.z*vVec.z;
	var_t c = sqrt(SQR(cVec.x) + SQR(cVec.y) + SQR(cVec.z));
    var_t l = sqrt(SQR(lVec.x) + SQR(lVec.y) + SQR(lVec.z));
	
    // Calculate eccentricity, e
    
    var_t e2 = 1.0 + 2.0 * SQR(c) * h / (mu * mu);
    if (abs(e2) < sq3)
    {
        e2 = 0.0;
    }
    var_t e = sqrt(e2);
    
    // Calculate semi-major axis, a
    
    var_t a = -mu / (2.0 * h);
    
    // Calculate inclination, incl
    
    var_t cosi = cVec.z / c;
    var_t sini = sqrt(SQR(cVec.x) + SQR(cVec.y)) / c;
    var_t incl = acos(cosi);
    if (incl < sq2)
    {
        incl = 0.0;
    }
	else if (incl > (PI - sq2))
	{
		incl = PI;
	}
        // Calculate longitude of node, O
    
    var_t node = 0.0;
    if (incl != 0.0 && incl != PI)
    {
        var_t tmpx = -cVec.y / (c * sini);
        var_t tmpy = cVec.x / (c * sini);
		node = atan2(tmpy, tmpx);
		shift_into_range(0.0, 2.0*PI, node);
    }
    
    // Calculate argument of pericenter, w (E excentric anomaly, H hyperbolic anomaly)
    
    var_t E = 0.0;
	var_t H = 0.0;
	var_t shH = 0.0;
    var_t peri = 0.0;
    if (e2 != 0.0)
    {
        var_t tmpx = (lVec.x * cos(node) + lVec.y * sin(node)) / l;
        var_t tmpy = (-lVec.x * sin(node) + lVec.y * cos(node)) / (l * cosi);
        peri = atan2(tmpy, tmpx);
        shift_into_range(0.0, 2.0*PI, peri);

		if (h >= 0.0)
		{
			shH = rv / ( SQR(a*mu) / CUBE(c) * e * pow(e2 - 1, 1.5));
			H = asinh(shH);	
		}
		else
		{
			tmpx = 1.0 / e * (1.0 - r / a);
			tmpy = rv / (sqrt(mu * a) * e);
			E = atan2(tmpy, tmpx);
			shift_into_range(0.0, 2.0*PI, E);
		}
    }
    else
    {
        peri = 0.0;
        E = atan2(rVec.y, rVec.x);
        shift_into_range(0, 2.0*PI, E);
    }
    
    // Calculate mean anomaly, M
   
	var_t M = 0.0;
	if (h >= 0.0)
	{
		M = e*shH - H;
	}
	else
	{
		M = E - e * sin(E);
		shift_into_range(0, 2.0*PI, M);
	}

	oe->sma		= a;
	oe->ecc		= e;
	oe->inc		= incl;
	oe->peri	= peri;
	oe->node	= node;
	oe->mean	= M;

	return 0;
}

void shift_into_range(const var_t lower, const var_t upper, var_t& value)
{
    double range = upper - lower;
    while (value >= upper)
    {
        value -= range;
    }
    while (value < lower)
    {
        value += range;
    }
}

var_t asinh(const var_t value)
{   
	var_t returned;

	if (value > 0)
	{
		returned = log(value + sqrt(value * value + 1));
	}
	else
	{
		returned = -log(-value + sqrt(value * value + 1));
	}
	return returned;
}

void print_vector(const vec_t *v)
{
	static int var_t_w  = 25;

	cout.precision(16);
	cout.setf(ios::right);
	cout.setf(ios::scientific);

	cout << setw(var_t_w) << v->x 
		 << setw(var_t_w) << v->y
		 << setw(var_t_w) << v->z
		 << setw(var_t_w) << v->w << endl;
}

} /* tools */
} /* redutilcu */
