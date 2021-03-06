// includes system
#include <algorithm>
#include <iomanip>
#include <fstream>

// includes project
#include "file_util.h"
#include "tools.h"
#include "red_macro.h"
#include "red_constants.h"

namespace redutilcu
{
namespace file
{
string combine_path(const string& dir, const string& filename)
{
	if (dir.size() > 0) {
		if (*(dir.end() - 1) != '/' && *(dir.end() - 1) != '\\') {
			return dir + '/' + filename;
		}
		else {
			return dir + filename;
		}
	}
	else {
		return filename;
	}
}

string get_filename(const string& path)
{
	string result;

	if (path.size() > 0)
	{
		size_t pos = path.find_last_of("/\\");
		result = path.substr(pos + 1);
	}

	return result;
}

string get_filename_without_ext(const string& path)
{
	string result;

	if (path.size() > 0)
	{
		size_t pos = path.find_last_of("/\\");
		result = path.substr(pos + 1);
		pos = result.find_last_of('.');
		result = result.substr(0, pos);
	}

	return result;
}

string get_directory(const string& path)
{
	string result;

	if (path.size() > 0)
	{
		size_t pos = path.find_last_of("/\\");
		result = path.substr(0, pos);
	}

	return result;
}

string get_extension(const string& path)
{
	string result;

	if (path.size() > 0)
	{
		size_t pos = path.find_last_of('.');
		result = path.substr(pos + 1);
	}

	return result;
}

void load_ascii_file(const string& path, string& result)
{
	std::ifstream file(path.c_str(), ifstream::in);
	if (file) {
		string str;
		while (getline(file, str))
		{
			// ignore zero length lines
			if (str.length() == 0)
				continue;
			// ignore comment lines
			if (str[0] == '#')
				continue;
			// delete comment after the value
			tools::trim_right(str, '#');
			result += str;
			result.push_back('\n');
		} 	
	}
	else {
		throw string("The file '" + path + "' could not opened!\r\n");
	}
	file.close();
}

void Emese_data_format_to_red_cuda_format(const string& input_path, const string& output_path)
{
	ifstream input(  input_path.c_str(), ios::in | ios::binary);
	ofstream output(output_path.c_str(), ios_base::out);

	if (!input)
	{
		throw string("The file '" + input_path + "' could not opened!\r\n");
	}
	if (!output)
	{
		throw string("The file '" + output_path + "' could not opened!\r\n");
	}

	output << "1 0 0 5000 0 0 5000" << endl;
	if (input && output) 
	{
		ttt_t time = 0.0;        
		int64_t nbodyfilein;
		int64_t lengthChar;      
		char buffer[64];
		var_t id = 0;
		string name;
		string reference;
		var_t x = 0;
		var_t y = 0;
		var_t z = 0;
		var_t vx = 0;
		var_t vy = 0;
		var_t vz = 0;
		var_t m = 0;
		var_t rad = 0;

		input.read(reinterpret_cast<char *>(&time), sizeof(time));
		input.read(reinterpret_cast<char *>(&nbodyfilein), sizeof(nbodyfilein));
		for (int i = 0; i < nbodyfilein; i++)
		{
			input.read(reinterpret_cast<char *>(&id), sizeof(id));

			lengthChar = 0;
			input.read(reinterpret_cast<char *>(&lengthChar), sizeof(lengthChar));            
			input.read(buffer, lengthChar);
			buffer[lengthChar] = 0;
			name = buffer;
			replace(name.begin(), name.end(), ' ', '_'); // replace all ' ' to '_'

			lengthChar = 0;
			input.read(reinterpret_cast<char *>(&lengthChar), sizeof(lengthChar));
			input.read(buffer, lengthChar);
			buffer[lengthChar] = 0;
			reference = buffer; 

			input.read(reinterpret_cast<char *>(&x),  sizeof( x));
			input.read(reinterpret_cast<char *>(&y),  sizeof( y));
			input.read(reinterpret_cast<char *>(&z),  sizeof( z));
			input.read(reinterpret_cast<char *>(&vx), sizeof(vx));
			input.read(reinterpret_cast<char *>(&vy), sizeof(vy));
			input.read(reinterpret_cast<char *>(&vz), sizeof(vz));
			input.read(reinterpret_cast<char *>(&m),  sizeof( m));
			input.read(reinterpret_cast<char *>(&rad),sizeof(rad));

			vec_t	rVec = {x, y, z, 0.0};
			vec_t	vVec = {vx, vy, vz, 0.0};

			param_t	        param;
            body_metadata_t body_md;

			// red.cuda: id starts from 1
			body_md.id = ++id;
			if (1 == body_md.id)
			{
				body_md.body_type = BODY_TYPE_STAR;
			}
			if (1 < body_md.id)
			{
				if (0.0 < m)
				{
					body_md.body_type = BODY_TYPE_PROTOPLANET;
				}
				else
				{
					body_md.body_type = BODY_TYPE_TESTPARTICLE;
				}
			}

			param.cd = 0.0;
			param.mass = m;
			param.radius = rad;
			param.density = tools::calculate_density(m, rad);
			body_md.mig_stop_at = 0.0;
			body_md.mig_type = MIGRATION_TYPE_NO;

			file::print_body_record(output, name, time, &param,&body_md, &rVec, &vVec);
		}
		input.close();
		output.close();
	}
	else
	{
		throw string("Error reading or writing in Emese_data_format_to_red_cuda_format() function!\r\n");
	}
}

void log_start_cmd(ostream& sout, int argc, const char** argv, const char** env)
{
	sout << tools::get_time_stamp() << " starting " << argv[0] << endl;
	sout << "Command line arguments: " << endl;
	for (int i = 1; i < argc; i++)
	{
		sout << argv[i] << SEP;
	}
	sout << endl << endl;

	while (*env)
	{
		string s = *env;
#ifdef __GNUC__
		// TODO
		if(      s.find("HOSTNAME=") < s.length())
		{
			sout << s << endl;
		}
		else if (s.find("USER=") < s.length())
		{
			sout << s << endl;
		}
		else if (s.find("OSTYPE=") < s.length())
		{
			sout << s << endl;
		}
#else
		if(      s.find("COMPUTERNAME=") < s.length())
		{
			sout << s << endl;
		}
		else if (s.find("USERNAME=") < s.length())
		{
			sout << s << endl;
		}
		else if (s.find("OS=") < s.length())
		{
			sout << s << endl;
		}
#endif
		env++;
	}
	sout << endl;
}

void log_rebuild_vectors(ostream& sout, ttt_t t)
{
	sout << tools::get_time_stamp() << " Rebuild the vectors and remove inactive bodies " << " t: " << scientific << std::setprecision(16) << t << endl;
}

void log_message(ostream& sout, string msg)
{
	sout << tools::get_time_stamp() << msg << endl;
}

void print_body_record(ofstream &sout, string name, var_t epoch, param_t *p, body_metadata_t *body_md, vec_t *r, vec_t *v)
{
	static int int_t_w  =  8;
	static int var_t_w  = 25;

	sout.precision(16);
	sout.setf(ios::right);
	sout.setf(ios::scientific);

	sout << setw(int_t_w) << body_md->id << SEP
		 << setw(     30) << name << SEP
		 << setw(      2) << body_md->body_type << SEP 
		 << setw(var_t_w) << epoch << SEP
		 << setw(var_t_w) << p->mass << SEP
		 << setw(var_t_w) << p->radius << SEP
		 << setw(var_t_w) << p->density << SEP
		 << setw(var_t_w) << p->cd << SEP
		 << setw(      2) << body_md->mig_type << SEP
		 << setw(var_t_w) << body_md->mig_stop_at << SEP
		 << setw(var_t_w) << r->x << SEP
		 << setw(var_t_w) << r->y << SEP
		 << setw(var_t_w) << r->z << SEP
		 << setw(var_t_w) << v->x << SEP
		 << setw(var_t_w) << v->y << SEP
		 << setw(var_t_w) << v->z << endl;

    sout.flush();
}

void print_body_record_HIPERION(ofstream &sout, string name, var_t epoch, param_t *p, body_metadata_t *body_md, vec_t *r, vec_t *v)
{
	static int ids[4] = {0, 10, 20, 10000000};

	static int int_t_w  =  8;
	static int var_t_w  = 25;

	sout.precision(16);
	sout.setf(ios::right);
	sout.setf(ios::scientific);

	int id = 0;
	// NOTE: this is not the beta parameter but derived from it
	var_t _beta = 0.0;
	switch (body_md->body_type)
	{
	case BODY_TYPE_STAR:
		id = ids[0];
		ids[0]++;
		_beta = 0.0;
		break;
	case BODY_TYPE_GIANTPLANET:
		id = ids[1];
		ids[1]++;
		_beta = 0.0;
		break;
	case BODY_TYPE_ROCKYPLANET:
		id = ids[1];
		ids[1]++;
		_beta = 0.0;
		break;
	case BODY_TYPE_PROTOPLANET:
		id = ids[2];
		ids[2]++;
		_beta = p->density;
		break;
	case BODY_TYPE_SUPERPLANETESIMAL:
		break;
	case BODY_TYPE_PLANETESIMAL:
		id = ids[2];
		ids[2]++;
		_beta = p->density;
		break;
	case BODY_TYPE_TESTPARTICLE:
		id = ids[3];
		ids[3]++;
		_beta = 1.0;
		break;
	}

	var_t eps = 0.0;

	sout << setw(int_t_w) << id      << SEP
		 << setw(var_t_w) << p->mass << SEP
		 << setw(var_t_w) << r->x    << SEP
		 << setw(var_t_w) << r->y    << SEP
		 << setw(var_t_w) << r->z    << SEP
		 << setw(var_t_w) << v->x / constants::Gauss << SEP
		 << setw(var_t_w) << v->y / constants::Gauss << SEP
		 << setw(var_t_w) << v->z / constants::Gauss << SEP
		 << setw(var_t_w) << eps     << SEP
		 << setw(var_t_w) << _beta   << endl;

    sout.flush();
}

void print_body_record_Emese(ofstream &sout, string name, var_t epoch, param_t *p, body_metadata_t *body_md, vec_t *r, vec_t *v)
{
	const char* body_type_name[] = 
	{
		"STAR",
		"GIANTPLANET",
		"ROCKYPLANET",
		"PROTOPLANET",
		"SUPERPLANETESIMAL",
		"PLANETESIMAL",
		"TESTPARTICLE",
	};

	static int int_t_w  = 25;
	static int var_t_w  = 25;

	sout.precision(16);
	sout.setf(ios::left);
	sout.setf(ios::scientific);

	// NOTE: Emese start the ids from 0, red starts from 1.
	sout << setw(int_t_w) << noshowpos << body_md->id - 1
		 << setw(     25) << name
		 << setw(     25) << noshowpos << body_type_name[body_md->body_type]
		 << setw(var_t_w) << showpos << r->x
		 << setw(var_t_w) << showpos << r->y
		 << setw(var_t_w) << showpos << r->z
		 << setw(var_t_w) << showpos << v->x
		 << setw(var_t_w) << showpos << v->y
		 << setw(var_t_w) << showpos << v->z
		 << setw(var_t_w) << showpos << p->mass
		 << setw(var_t_w) << showpos << p->radius << endl;

    sout.flush();
}

void print_oe_record(ofstream &sout, orbelem_t* oe)
{
	static int var_t_w  = 15;

	sout.precision(6);
	sout.setf(ios::right);
	sout.setf(ios::scientific);

	sout << setw(var_t_w) << oe->sma << SEP 
         << setw(var_t_w) << oe->ecc << SEP 
         << setw(var_t_w) << oe->inc << SEP 
         << setw(var_t_w) << oe->peri << SEP 
         << setw(var_t_w) << oe->node << SEP 
         << setw(var_t_w) << oe->mean << endl;

	sout.flush();
}

} /* file */
} /* redutilcu */
